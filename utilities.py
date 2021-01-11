import os
import numpy as np
import h5py
import librosa
import wave
import glob
import scipy.io.wavfile as wv
import csv
import sys
import tensorflow as tf
from keras.models import Sequential,Model,load_model,save_model
from keras.layers import Dense, Dropout, LSTM, BatchNormalization,Flatten,Conv2D,MaxPooling2D,Input,LeakyReLU,ReLU,Softmax
from keras.callbacks import TensorBoard
from keras.callbacks import ModelCheckpoint
from keras.losses import categorical_crossentropy
from keras.utils import to_categorical
from sklearn.model_selection import ShuffleSplit,train_test_split,KFold
from sklearn.metrics import confusion_matrix
from kerassurgeon.operations import delete_channels
import keras
import numpy as np
from sklearn.cluster import KMeans,MiniBatchKMeans
from keras.models import load_model
from keras.utils import to_categorical
from sklearn.model_selection import ShuffleSplit





def prune_filters(lm,thres, test_data, test_labels, train_data, train_labels, batch_size, epochs):
    pruninglist=[]
    # Pruning Criteria
    for l in lm.layers:
        if 'conv2d' in l.name:
            w = l.get_weights()[0]
            totSumPerLayer=np.sum(np.abs(w))
            for i in range(w.shape[3]):
                kernelsum=np.sum(np.abs(w[:,:,:,i]))
                pruninglist.append({
                    'name':l.name,
                    'kernelIndex':i,
                    'kernelSum':kernelsum,
                    'kernelSumNormalized':kernelsum/totSumPerLayer})
    pruninglistsorted=sorted(pruninglist, key = lambda i: i['kernelSumNormalized'])
    layernames=[i['name'] for i in pruninglist]
    layernamesunique=[]
    for layername in layernames:
        if layername not in layernamesunique:
            layernamesunique.append(layername)
    for layername in layernames:
        operatedLayer = lm.get_layer(name=layername)
        kernelsbylayer=[i for i in pruninglist if i['name']==layername]
        kernelsbylayerSorted=sorted(kernelsbylayer, key = lambda i: i['kernelSum'])
        index_list=[i['kernelIndex'] for i  in kernelsbylayerSorted]
        index_list=index_list[:thres]
        print("Delete for layer " + layername)
        lm = delete_channels(lm, operatedLayer, index_list)  # Function of keras surgeon library to prune channels
        operatedLayer.trainable = False
        lm.compile(loss=categorical_crossentropy, optimizer='adam', metrics=['accuracy'])
        accuracy = []
        loss = []
        kf = ShuffleSplit(n_splits=4, test_size=0.15)
        for train_index, test_index in kf.split(train_data):
            data_train, data_test = train_data[train_index], train_data[test_index]
            label_train, label_test = train_labels[train_index], train_labels[test_index]
            inhaler_train = lm.fit(data_train, label_train, batch_size=batch_size, epochs=epochs, verbose=1)
            # evaluation
            test_eval = lm.evaluate(data_test, label_test, verbose=1)
            loss.append(test_eval[0])
            accuracy.append(test_eval[1])
        print('The validation accuracy of the classifier is: ', sum(accuracy) / len(accuracy))

    for layer in lm.layers:  # when pruning of all convolutional layers is finished the network is restored to trainable.
        layer.trainable = True
        lm.compile(loss=categorical_crossentropy, optimizer='adam', metrics=['accuracy'])

    lm.save('Prune_fmaps_' + str(thres) + '_model_1.h5py')
    print('Pruning is completed')
    count_weights('Prune_fmaps_' + str(thres) + '_model_1.h5py', test_data, test_labels)

def count_weights(model_name, dataset, labels):
    model = load_model(model_name)
    test_eval = model.evaluate(dataset, labels, verbose=0)
    print('Test loss for sparse model : ', test_eval[0])
    print('Test accuracy for sparse model : ', test_eval[1])

#######################################################################################################################
#######################################################################################################################


def product_quantization_convolutional_layer(model, s, clusters):
    # Function that gathers the weights through the channels.
    # The parameters passed are a pre-trained model, the parameter s which divide the initial weight matrix
    # to sub-matrices and clusters which is the number of different representative values kmeans should produce.
    # the initial weight matrix is splitted from m*n*d*c to m*n*d*(c/s) where c number of channels.

    for layer in model.layers:  # iteration only in convolutional layers.
        if 'conv2d' in l.name:  # there are layers inbetween the convolutional layers that do not contain trainable parameters. No action needed for them.
            weights = layer.get_weights()[0]  # numpy matrix of the weights of a layer. Channels are last. 4d matrix and the dimesnion sequence is x,y,z,channel.
            bias = layer.get_weights()[1]
            parameter_list = []
            # 4 for loops to iterate through the weight matrix.
            # kmeans is executed in channels to produce same kernels and consequnetly same feature maps
            for i in range(weights.shape[0]):
                for j in range(weights.shape[1]):
                    for k in range(weights.shape[2]):
                        weight_list = []  # list with weights in the channel  axis
                        for l in range(weights.shape[3]):
                            weight_list.append(weights[i][j][k][l])
                        # new_weight_list contains the values produced from kmeans
                        updated_weight_list = clustering(weight_list, s,clusters)
                        for w in range(len(updated_weight_list)):  # iteration to replace the old values with the new, computed from kmeans.
                            weights[i][j][k][w] = updated_weight_list[w]
            parameter_list.append(weights)
            parameter_list.append(bias)
            layer.set_weights(parameter_list)
    print('Convolutional layers processing is completed.')
    return model


def product_quantization_fully_connected_layer(model, s, clusters):
    # Function the gathers the weights that belong to the same row of the weight matrix.
    # In this way, with kmeans, we produce same neurons and we avoid both storing weight values and flops.
    # The parameters are the same with those in the convolutional_layer function.
    # The weight matrix a 2d tensor of mχn. With s is splitted to sub-matrices of mχ(n/s).
    # Pruning Criteria

    for l in model.layers:
        if 'dense' in l.name:
            weights = l.get_weights()[0]
            bias = l.get_weights()[1]
            parameter_list = []
            for i in range(weights.shape[0]):
                weight_list = []
                for j in range(weights.shape[1]):
                    weight_list.append(weights[i][j])
                updated_weight_list = clustering(weight_list, s, clusters)
                for w in range(weights.shape[1]):
                    weights[i][w] = updated_weight_list[w]
            parameter_list.append(weights)
            parameter_list.append(bias)
            l.set_weights(parameter_list)

    print('Fully connected layers processing is completed.')
    return model




def clustering(weight_list, s, clusters):
    # Function that executes the kmeans algorithms on a given space.
    # Weight_list contains the weights of a layer. For convolutional layers kmeans is performed on channels axis
    # For fully connected layer weigths belong to the same row of the initial weight matrix.
    # s, clusters parameters are explained in convolutional_layer function
    for i in range(s):
        index = int(len(weight_list) / s)
        my_list = weight_list[index * i:index * i + index]
        my_list = np.reshape(my_list, (len(my_list), 1))
        kmeans = KMeans(n_clusters=clusters).fit(my_list)
        predictions = kmeans.predict(my_list)
        centers = kmeans.cluster_centers_
        for j in range(len(predictions)):
            weight_list[(i * index) + j] = centers[predictions[j]][0]
    return weight_list


def calculate_accuracy(model_name, dataset, labels):
    model = load_model(model_name)
    test_eval = model.evaluate(dataset, labels, verbose=0)
    print('Test loss for sparse model : ', test_eval[0])
    print('Test accuracy for sparse model : ', test_eval[1], '\n')


def sparsify_model(pModel,l,data_train,label_train,batch_size,epochs,data_test,label_test,doRetraining=True):
    for layer in pModel.layers:
        my_list = []  # list that will contain the new values of the parameters
        if 'conv2d' in layer.name:
            # if layer.get_weights()!=[]:

            weights = layer.get_weights()[0]
            deviation = np.std(weights)  # standard deviation of the weights
            with np.nditer(weights, op_flags=['readwrite']) as it:  # iteration in the weight matrix of the layer
                for x in it:
                    if abs(x) < l * deviation:
                        x[...] = 0
            my_list.append(weights)
            my_list.append(layer.get_weights()[1])
            layer.set_weights(my_list)
            layer.trainable = False  # every layer, that is processed, is freezed so that its parameters will not be updated with retraining
            pModel.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.Adam(),
                           metrics=['accuracy'])

            if doRetraining:
                accuracy = []
                loss = []
                pModel_train = pModel.fit(data_train, label_train, batch_size=batch_size, epochs=epochs,
                                           verbose=1)
                # evaluation
                test_eval = pModel.evaluate(data_test, label_test, verbose=1)
                print('Val loss:', test_eval[0])
                loss.append(test_eval[0])
                print('Val accuracy:', test_eval[1])
                accuracy.append(test_eval[1])
                print(loss)
                print(accuracy)
                print('The validation accuracy of the classifier is: ', sum(accuracy) / len(accuracy))
    for layer in pModel.layers:
        layer.trainable = True
    pModel.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.Adam(), metrics=['accuracy'])

    return pModel




from network import build_model
from keras import backend as K

def train_single_fold(data_train, label_train,num_classes,batch_size,epochs,fromScratch,doStore,trainedModelName):

    def get_session(gpu_fraction=0.333):
        gpu_options = tf.GPUOptions(
            per_process_gpu_memory_fraction=gpu_fraction,
            allow_growth=True)
        return tf.Session(config=tf.ConfigProto(gpu_options=gpu_options))


    K.set_session(get_session())

    inhaler_model = build_model(data_train.shape[1:], num_classes)
    inhaler_model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    inhaler_model.summary()
    if fromScratch:
        inhaler_train = inhaler_model.fit(data_train, label_train, batch_size=batch_size, epochs=epochs, verbose=1)
        if doStore == True:
            inhaler_model.save(trainedModelName)
    else:
        inhaler_model.load_weights(trainedModelName)
    return inhaler_model