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
from keras.utils import to_categorical
# from tensorflow.keras.layers.advanced_activations import ELU
from sklearn.model_selection import ShuffleSplit,train_test_split,KFold
from sklearn.metrics import confusion_matrix
from kerassurgeon.operations import delete_channels
import keras.backend as K
import copy
import random

from config import *
from dataread import fetchAnnotatedFilenames,fetchDataAndlabels,getDataSets
from network import build_model

from utilities import *
from utilities import train_single_fold

# Override config
fromScratch=True
doStore=False
filenames,annotation=fetchAnnotatedFilenames()
random.Random(9).shuffle(filenames)
data_train,label_train,data_test,label_test=getDataSets(filenames,annotation,classes)
p_class = []
t_class = []
inhaler_model=train_single_fold(
    data_train,
    label_train,
    num_classes,
    batch_size,
    epochs,
    fromScratch=fromScratch,
    doStore=doStore,
    trainedModelName=trainedModel)

# number of clusters to quantize with kmeans. Several number have been tested.
c = [1, 2]

# segmentation coefficient for  splitting the vector in smaller sub-vectors. Results for s=1,2,4 are available.
s = 2

print('Quantizing model')
for clusters_conv in c:
    loaded_dense_model = copy.deepcopy(inhaler_model)
    print('Clusters in convolutional layers:', clusters_conv)
    print('Splitting coefficient:', s)
    # updated_model=product_quantization_convolutional_layer(loaded_dense_model,s,clusters_conv) #uncomment it if product quantization is to be executed on convolutional layer
    updated_model = product_quantization_fully_connected_layer(loaded_dense_model, s, clusters_conv)
    updated_model.save('product_vq_s=' + str(s) + '_d=' + str(clusters_conv))
    calculate_accuracy('product_vq_s=' + str(s) + '_d=' + str(clusters_conv), data_test, label_test)
