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


prediction = inhaler_model.predict(data_test)
p_class.extend(np.argmax(prediction, axis=1).tolist())
t_class.extend(np.argmax(label_test, axis=1).tolist())
cm = confusion_matrix(t_class, p_class)
print(cm)
cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
print(cm)

exit(0)
