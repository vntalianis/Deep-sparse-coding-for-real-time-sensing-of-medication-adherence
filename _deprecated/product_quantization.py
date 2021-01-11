import os
import keras
import librosa
import numpy as np

from sklearn.cluster import KMeans,MiniBatchKMeans

from keras.models import load_model
from keras.utils import to_categorical
from sklearn.model_selection import ShuffleSplit

def extract_features(filename):
    #Function to load the audio file.
    X,sample_rate=librosa.load(filename,sr=8000) 
    return X

def test_dataset():
    #Function to create the test dataset.
    #It is used only for classification accuracy evaluation and not for training. 
    print('Creating test dataset.')
    empty_mat=np.empty([0,250,16])#The input of CNN has 250x16x1 shape
    count=0
    for filename in os.listdir(r"C:\Users\Vaggelis Dalianis\Desktop\Thesis\MyDataset\test dataset"): 
        if filename.endswith('.wav'):
            X=extract_features(filename)
            X.resize((1,250,16))
            if count==0:
                dt=np.append(empty_mat,X,axis=0)
                
            else:
                dt=np.append(dt,X,axis=0)
    print('Test dataset creation is completed.')
    return dt

def create_test_label():
    #Function to create the labels of test dataset.
    #Labels are one-hot encoded using the build in function, to_categorical()
    print('Creating test labels.')
    label=[]
    for filename in os.listdir(r"C:\Users\vaggelis Dalianis\Desktop\Thesis\MyDataset\test dataset"):
        if filename.endswith('.wav'):
            if filename.startswith('Exhale'):
                label.append(0)
            elif filename.startswith('Inhale'):
                label.append(1)
            elif filename.startswith('Drug'):
                label.append(2)
            else:
                label.append(3)
    label=to_categorical(label)
    print('Test labels creation is completed.')
    return label

def convolutional_layer(model,s,clusters):
    #Function that gathers the weights through the channels.
    #The parameters passed are a pre-trained model, the parameter s which divide the initial weight matrix
    #to sub-matrices and clusters which is the number of different representative values kmeans should produce.
    #the initial weight matrix is splitted from m*n*d*c to m*n*d*(c/s) where c number of channels.
    
    for layer in model.layers[0:7]:#iteration only in convolutional layers. 
        if layer.get_weights()!=[]:#there are layers inbetween the convolutional layers that do not contain trainable parameters. No action needed for them.
            weights=layer.get_weights()[0]#numpy matrix of the weights of a layer. Channels are last. 4d matrix and the dimesnion sequence is x,y,z,channel. 
            bias=layer.get_weights()[1]
            parameter_list=[]
            #4 for loops to iterate through the weight matrix.
            #kmeans is executed in channels to produce same kernels and consequnetly same feature maps 
            for i in range(weights.shape[0]):
                for j in range(weights.shape[1]):
                    for k in range(weights.shape[2]):
                        weight_list=[] #list with weights in the channel  axis
                        for l in range(weights.shape[3]):
                            weight_list.append(weights[i][j][k][l])
                        new_weight_list=clustering(weight_list,s,clusters)#new_weight_list contains the values produced from kmeans
                        for w in range(len(new_weight_list)):#iteration to replace the old values with the new, computed from kmeans.
                            weights[i][j][k][w]=new_weight_list[w]
            parameter_list.append(weights)
            parameter_list.append(bias)
            layer.set_weights(parameter_list)
    print('Convolutional layers processing is completed.')
    return model

def fully_connected_layer(model,s,clusters):
    #Function the gathers the weights that belong to the same row of the weight matrix.
    #In this way, with kmeans, we produce same neurons and we avoid both storing weight values and flops.
    #The parameters are the same with those in the convolutional_layer function.
    #The weight matrix a 2d tensor of mχn. With s is splitted to sub-matrices of mχ(n/s).

    for layer in model.layers[8:12]:
        if layer.get_weights()!=[]:
            weights=layer.get_weights()[0]
            bias=layer.get_weights()[1]
            parameter_list=[]
            for i in range(weights.shape[0]):
                weight_list=[]
                for j in range(weights.shape[1]):
                    weight_list.append(weights[i][j])
                new_weight_list=clustering(weight_list,s,clusters)
                for w in range(weights.shape[1]):
                    weights[i][w]=new_weight_list[w]
            parameter_list.append(weights)
            parameter_list.append(bias)
            layer.set_weights(parameter_list)
    print('Fully connected layers processing is completed.')
    return model

def clustering(weight_list,s,clusters):
    #Function that executes the kmeans algorithms on a given space.
    #Weight_list contains the weights of a layer. For convolutional layers kmeans is performed on channels axis
    #For fully connected layer weigths belong to the same row of the initial weight matrix.
    #s, clusters parameters are explained in convolutional_layer function 
    for i in range(s):
        index=int(len(weight_list)/s)
        my_list=weight_list[index*i:index*i+index]
        my_list=np.reshape(my_list,(len(my_list),1))
        kmeans=KMeans(n_clusters=clusters).fit(my_list)
        predictions=kmeans.predict(my_list)
        centers=kmeans.cluster_centers_
        for j in range(len(predictions)):
            weight_list[(i*index)+j]=centers[predictions[j]][0]
    return weight_list

def calculate_accuracy(model_name,dataset,labels):
    model=load_model(model_name)
    test_eval=model.evaluate(dataset,labels,verbose=0)
    print('Test loss for sparse model : ', test_eval[0])
    print('Test accuracy for sparse model : ',test_eval[1],'\n')

path='C:/Users/vaggelis Dalianis/Desktop/Thesis/MyDataset/test dataset/'
model=[#'inhaler_model_1.h5py',
        'inhaler_model_2.h5py',
        'inhaler_model_3.h5py']
        #'inhaler_model_4.h5py',
       #'inhaler_device_model_v2.h5py']


test_labels=create_test_label()
test_data=test_dataset()
test_data.resize(len(test_data),250,16,1)

c=[1,2]#number of clusters to quantize with kmeans. Several number have been tested.
s=2#segmentation coefficient for  splitting the vector in smaller sub-vectors. Results for s=1,2,4 are available.


for dense_model in model:
    print('Quantizing model:', dense_model)
    for clusters_conv in c:
        loaded_dense_model=load_model(path+dense_model)
        print('Clusters in convolutional layers:',clusters_conv)
        print('Splitting coefficient:',s)
        ##my_model=convolutional_layer(loaded_dense_model,s,clusters_conv) #uncomment it if product quantization is to be executed on convolutional layer
        my_model=fully_connected_layer(loaded_dense_model,s,clusters_conv) 
        my_model.save('product_vq_s='+str(s)+'_d='+str(clusters_conv)+'_'+dense_model)
        calculate_accuracy('product_vq_s='+str(s)+'_d='+str(clusters_conv)+'_'+dense_model,test_data,test_labels)
