import os
import h5py
import librosa
import numpy as np
from keras.utils import to_categorical
import wave
import os
import glob
import scipy
import csv
from sklearn.metrics import confusion_matrix
import keras
from keras.models import Sequential,Input,Model
from keras.layers import Dense,Dropout,Flatten
from keras.layers import Conv2D,MaxPooling2D
from keras.layers.advanced_activations import ELU
from sklearn.model_selection import ShuffleSplit,train_test_split,KFold
from sklearn.metrics import confusion_matrix
import tensorflow as tf
import keras.backend.tensorflow_backend as ktf
from keras.models import load_model
from kerassurgeon.operations import delete_channels


#function to extract audio files
def extract_features(filename):
    X,sample_rate=librosa.load(filename,sr=8000) #sr=sampling rate
    return X ##X is a vector with arithmetic values of the audio file as produced by librosa library

##function to load audio files and save them in a numpy two dimesnional matrix
def feature_dataset():
    empty_mat=np.empty([0,250,16])##length of audio files:0.5 seconds. For sampling rate=8000, we have 4000 values hence 250x16
    count=0
    for filename in os.listdir(path):
        if filename.endswith('.wav'):
            X=extract_features(path+filename)
            X.resize((1,250,16)) ##extract_features() returns a vector of 1x4000
            if count==0:
                dt=np.append(empty_mat,X,axis=0)

            else:
                dt=np.append(dt,X,axis=0)
            count+=1
    return dt ##two-dimensional matrix which will be input to the classifier

np.set_printoptions(formatter={'float': lambda x: "{0:0.3f}".format(x)})

classes=['Exhale','Inhale','Drug','Noise'] #four classes of the respiratory phases. 
path="C:/Users/vaggelis Dalianis/Desktop/Thesis/Dropbox Dataset/" #path the recordigs are stored
#X=np.empty([0,250,16])
Y=[]#classes for train dataset
X=[]#training dataset

Y_test=[]#classes for test dataset
X_test=[]#test dataset

ind=0
f1=glob.glob(os.path.join(path+'_f1/', '*.wav')) #f1 corresponds to first male subject
g1=glob.glob(os.path.join(path+'_g1/', '*.wav')) #g1 refers to second male subject
a1=glob.glob(os.path.join(path+'_a1/', '*.wav')) #a1 corresponds to female subject
annotation_f1=np.genfromtxt(path+'_f1/'+'annotation.csv', delimiter=',',dtype='<U50')
annotation_g1=np.genfromtxt(path+'_g1/'+'annotation.csv', delimiter=',',dtype='<U50')
annotation_a1=np.genfromtxt(path+'_a1/'+'annotation.csv', delimiter=',',dtype='<U50')


p_class = []
t_class = []
fld=0#number of fold

print('Leave one out method. _g1 for test')
train_files=f1
train_files.extend(g1)
test_files=a1 #in this variable is assigned the folder with the subject's recordings that are left out.
train_annotation=np.concatenate((annotation_f1, annotation_g1))
test_annotation=annotation_a1

for filename in train_files:
    ind=ind+1
    w = scipy.io.wavfile.read(filename)
    w_=wave.openfp(filename)
    maxval=2**((w_.getsampwidth()*(8)-1))
    fs=w[0]
    audioData=w[1]
    audioData = audioData / maxval
    audioData=(audioData+1)/2
    head_tail = os.path.split(filename)
    A=train_annotation[train_annotation[:,0]==head_tail[1],:]
    for row in A:
        mLabel=row[1]
        startA=int(row[2])#sample from which the respiratory phase begins
        stopA=int(row[3])#sample at which the respiratory phase stops
        for i in range(startA,(stopA-4000),500):#loop to slide a window of size 4000 with step of 500 samples. There is an overlapping of 3500 samples.
            c=classes.index(mLabel)
            Y.append(c)
            dat=np.asarray(audioData[i:i+4000])
            dat.resize((1, 250, 16))
            X.append(dat)
print('Training files OK')

for filename in test_files:
    ind=ind+1
    w = scipy.io.wavfile.read(filename)
    w_=wave.openfp(filename)
    maxval=2**((w_.getsampwidth()*(8)-1))
    fs=w[0]
    audioData=w[1]
    audioData = audioData / maxval
    audioData=(audioData+1)/2
    head_tail = os.path.split(filename)
    A=test_annotation[test_annotation[:,0]==head_tail[1],:]
    for row in A:
        mLabel=row[1]
        startA=int(row[2])
        stopA=int(row[3])
        for i in range(startA,(stopA-4000),500):
            c=classes.index(mLabel)
            Y_test.append(c)
            dat=np.asarray(audioData[i:i+4000])
            dat.resize((1, 250, 16))
            X_test.append(dat)
print('Test files OK')


data_train=np.asarray(X)
label_train=to_categorical(Y,4)
data_train.resize(len(data_train),250,16,1)

data_test=np.asarray(X_test)
label_test=to_categorical(Y_test,4)
data_test.resize(len(data_test),250,16,1)


batch_size=100
epochs=20
num_classes=4

##CNN Architecture
inhaler_model=Sequential()
inhaler_model.add(Conv2D(16,kernel_size=(4,4),activation='elu',input_shape=(250,16,1),padding='same',use_bias=True)) # activation can be linear,relu,elu etc
inhaler_model.add(MaxPooling2D((2,2),padding='same'))
inhaler_model.add(Dropout(0.2))
inhaler_model.add(Conv2D(16, (5,5), activation='elu',padding='same',use_bias=True))
inhaler_model.add(MaxPooling2D(pool_size=(2,2),padding='same'))
inhaler_model.add(Dropout(0.1))
inhaler_model.add(Conv2D(16, (6,6), activation='elu',padding='same',use_bias=True))
inhaler_model.add(MaxPooling2D(pool_size=(2,2),padding='same'))
inhaler_model.add(Flatten())
inhaler_model.add(Dense(64, activation='elu'))
inhaler_model.add(Dense(128, activation='elu'))
inhaler_model.add(Dense(64, activation='elu'))
inhaler_model.add(Dense(num_classes, activation='softmax'))
inhaler_model.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.Adam(),metrics=['accuracy'])
print('Beginning of training')

inhaler_train = inhaler_model.fit(data_train, label_train,batch_size=batch_size,epochs=epochs,verbose=0)
prediction = inhaler_model.predict(data_test)
p_class.extend(np.argmax(prediction, axis=1).tolist())
t_class.extend(np.argmax(label_test, axis=1).tolist())

cm = confusion_matrix(t_class, p_class)
print(cm)
cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]#total sum of the confusion matrices. Devided by the number of folds gives the average perfomrnce of the classifier.
print(cm)
