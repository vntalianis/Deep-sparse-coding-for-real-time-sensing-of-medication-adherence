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

per = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0]  # percentages of the standard deviation.
pModel = copy.deepcopy(inhaler_model)
for l in per:
    print('Starting pruning and fine tuning with l=', l, '\n')
    pModel = sparsify_model(pModel, l, data_train, label_train, batch_size, epochs, data_test, label_test,
                            doRetraining=True)
    print('Pruning with threshold ', l, ' :is completed')
    test_eval = pModel.evaluate(data_test, label_test, verbose=0)  # evaluation of the pruned model
    print('Test loss for sparse model with threshold ', l, ' : ', test_eval[0])
    print('Test accuracy for sparse model with threshold ', l, ' : ', test_eval[1])
    # counter for the number of zeroed out parameters
    zero_counter = 0
    for layer in pModel.layers:
        # if layer.get_weights()!=[]:
        if 'conv2d' in layer.name:
            weights = layer.get_weights()[0]
            for w in np.nditer(weights):
                if w == 0:
                    zero_counter += 1
    print('Number of weights zeroed out for threshold ', l, ' : ', zero_counter, '\n')
