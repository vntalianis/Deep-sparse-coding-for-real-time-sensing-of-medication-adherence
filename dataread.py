import numpy as np
import wave
import os
import glob
import scipy.io.wavfile as wv
from keras.models import Sequential,Model,load_model,save_model
from keras.layers import Dense, Dropout, LSTM, BatchNormalization,Flatten,Conv2D,MaxPooling2D,Input,LeakyReLU,ReLU,Softmax
from keras.callbacks import TensorBoard
from keras.callbacks import ModelCheckpoint
from keras.losses import categorical_crossentropy
from keras.utils import to_categorical
from sklearn.model_selection import ShuffleSplit,train_test_split,KFold
from config import path


def fetchAnnotatedFilenames():
    f1=glob.glob(os.path.join(path+'_f1/', '*.wav'))
    g1=glob.glob(os.path.join(path+'_g1/', '*.wav'))
    a1=glob.glob(os.path.join(path+'_a1/', '*.wav'))
    annotation_f1=np.genfromtxt(path+'_f1/'+'annotation.csv', delimiter=',',dtype='<U50')
    annotation_g1=np.genfromtxt(path+'_g1/'+'annotation.csv', delimiter=',',dtype='<U50')
    annotation_a1=np.genfromtxt(path+'_a1/'+'annotation.csv', delimiter=',',dtype='<U50')
    filenames=f1
    filenames.extend(g1)
    filenames.extend(a1)
    annotation = np.concatenate((annotation_f1, annotation_g1, annotation_a1))
    return filenames,annotation

def fetchDataAndlabels(train_files,annotation,classes):
    Y = []
    X = []
    for filename in train_files:
        w = wv.read(filename)
        w_ = wave.openfp(filename)
        maxval = 2 ** ((w_.getsampwidth() * (8) - 1))
        fs = w[0]
        audioData = w[1]
        audioData = audioData / maxval
        audioData = (audioData + 1) / 2
        head_tail = os.path.split(filename)
        A = annotation[annotation[:, 0] == head_tail[1], :]
        for row in A:
            mLabel = row[1]
            startA = int(row[2])
            stopA = int(row[3])
            for i in range(startA, (stopA - 4000), 100):
                c = classes.index(mLabel)
                Y.append(c)
                # print(c)
                dat = np.asarray(audioData[i:i + 4000])
                # dat= (dat+np.ones(np.shape(dat)))/2
                dat.resize((1, 250, 16))
                X.append(dat)
                # X=np.concatenate((X,dat),axis=0)
                # print('ok')

    return X,Y


def getDataSets(filenames,annotation,classes):
    train_fnms, test_fnms=next(iter(KFold(10, True).split(filenames)))

    # Trainset
    train_files = [filenames[i] for i in train_fnms]
    X, Y = fetchDataAndlabels(train_files, annotation, classes)
    data_train = np.asarray(X)
    label_train = to_categorical(Y)
    data_train.resize(len(data_train), 250, 16, 1)

    # Testset
    test_files = [filenames[i] for i in test_fnms]
    X_test, Y_test = fetchDataAndlabels(test_files, annotation, classes)
    data_test = np.asarray(X_test)
    label_test = to_categorical(Y_test)
    data_test.resize(len(data_test), 250, 16, 1)
    return data_train,label_train,data_test,label_test