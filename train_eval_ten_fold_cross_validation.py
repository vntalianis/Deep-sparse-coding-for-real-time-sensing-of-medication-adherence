import h5py
import librosa
import numpy as np
import wave
import os
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
from tensorflow.keras.utils import to_categorical
# from tensorflow.keras.layers.advanced_activations import ELU
# import keras.backend.tensorflow_backend as ktf
from sklearn.model_selection import ShuffleSplit,train_test_split,KFold
from sklearn.metrics import confusion_matrix
from kerassurgeon.operations import delete_channels
import keras.backend as K
from utilities import *
import copy
import random

from config import *
from dataread import fetchAnnotatedFilenames,fetchDataAndlabels
from network import build_model


np.set_printoptions(formatter={'float': lambda x: "{0:0.3f}".format(x)})
filenames,annotation=fetchAnnotatedFilenames()
random.Random(9).shuffle(filenames)
fromScratch=True
doStore=False
p_class = []
t_class = []

for train_fnms, test_fnms in KFold(10, True).split(filenames):

    # Trainset
    train_files = [filenames[i] for i in train_fnms]
    X,Y=fetchDataAndlabels(train_files,annotation,classes)
    data_train=np.asarray(X)
    label_train=to_categorical(Y)
    data_train.resize(len(data_train),250,16,1)

    # Testset
    test_files = [filenames[i] for i in test_fnms]
    X_test,Y_test=fetchDataAndlabels(test_files,annotation,classes)
    data_test=np.asarray(X_test)
    label_test=to_categorical(Y_test)
    data_test.resize(len(data_test),250,16,1)

    def get_session(gpu_fraction=0.333):
        gpu_options = tf.GPUOptions(
            per_process_gpu_memory_fraction=gpu_fraction,
            allow_growth=True)
        return tf.Session(config=tf.ConfigProto(gpu_options=gpu_options))
    K.set_session(get_session())

    inhaler_model = build_model(data_train.shape[1:],num_classes)
    inhaler_model.compile(loss='categorical_crossentropy', optimizer='adam',metrics=['accuracy'])
    inhaler_model.summary()
    if fromScratch:
        inhaler_train = inhaler_model.fit(data_train, label_train,batch_size=batch_size,epochs=epochs,verbose=1)
        if doStore==True:
            inhaler_model.save(trainedModel)
    else:
        inhaler_model.load_weights(trainedModel)


    prediction = inhaler_model.predict(data_test)
    p_class.extend(np.argmax(prediction, axis=1).tolist())
    t_class.extend(np.argmax(label_test, axis=1).tolist())
    cm = confusion_matrix(t_class, p_class)
    print(cm)
    cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
    print(cm)

    exit(0)




