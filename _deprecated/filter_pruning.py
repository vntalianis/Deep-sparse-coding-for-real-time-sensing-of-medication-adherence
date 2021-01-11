import os
import keras
import librosa
import numpy as np
from keras.models import load_model
from keras.utils import to_categorical
from sklearn.model_selection import ShuffleSplit
from kerassurgeon.operations import delete_channels

def extract_features(filename):
    #Function to load an audio file
    X,sample_rate=librosa.load(filename,sr=8000) 
    return X

def test_dataset():
    #Function to create the test dataset
    #it is used only to calculate classification accuracy, not for training.
    print('Creating test dataset.')
    empty_mat=np.empty([0,250,16])
    count=0
    for filename in os.listdir(r"C:\Users\Vaggelis Dalianis\Desktop\Thesis\MyDataset\test dataset"): 
        if filename.endswith('.wav'):
            X=extract_features(filename)
            X.resize((1,250,16))
            if count==0:
                dt=np.append(empty_mat,X,axis=0)
                
            else:
                dt=np.append(dt,X,axis=0)
            count+=1
    print('Test dataset creation is completed.')
    return dt

def train_dataset():
    #Function to create the dataset used in training.
    print('Creating train dataset.')
    empty_mat=np.empty([0,250,16])
    count=0
    for filename in os.listdir(r"C:\Users\Vaggelis Dalianis\Desktop\Thesis\MyDataset\training dataset"): 
        if filename.endswith('.wav'):
            X=extract_features(r"C:\Users\Vaggelis Dalianis\Desktop\Thesis\MyDataset\training dataset\\"+filename)
            X.resize((1,250,16))
            if count==0:
                dt=np.append(empty_mat,X,axis=0)
                
            else:
                dt=np.append(dt,X,axis=0)
            count+=1
    print('Train dataset creation is completed.')
    return dt

def create_train_label():
    print('Creating train labels.')
    label=[]
    for filename in os.listdir(r"C:\Users\vaggelis Dalianis\Desktop\Thesis\MyDataset\training dataset"):
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
    print('Train labels creation is completed.')
    return label

def create_test_label():
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

def sort_filters(lm):
    #loop for the convolutional layers only.
    #Sorts the kernels by ascending order.
    for l in lm.layers[0:7]:
        if l.get_weights()!=[]:
            w=l.get_weights()[0]
            s=[]
            for i in range(w.shape[3]):
                athroisma=0
                for z in range(w.shape[2]):
                    for j in range(w.shape[1]):
                        for k in range(w.shape[0]):
                            athroisma+=abs(w[k][j][z][i])
                s.append(athroisma)
            yield np.argsort(s) #returns the indexes of the filters sorted
            
def split_data(inhaler_model,dataset,labels,batch_size,epochs):
    #Function to perform 4-fold cross validation
    accuracy=[]
    loss=[]
    kf=ShuffleSplit(n_splits=4,test_size=0.15)
    for train_index,test_index in kf.split(dataset):
        data_train,data_test=dataset[train_index],dataset[test_index]
        label_train,label_test=labels[train_index],labels[test_index]
        inhaler_train = inhaler_model.fit(data_train, label_train, batch_size=batch_size,epochs=epochs,verbose=0)
        #evaluation
        test_eval = inhaler_model.evaluate(data_test, label_test, verbose=0)
        loss.append(test_eval[0])
        accuracy.append(test_eval[1])
    print('The validation accuracy of the classifier is: ',sum(accuracy)/len(accuracy))

def prune_filters(filters,thres,lm,test_data,test_labels,train_data,train_labels,batch_size,epochs):
    print('Start pruning with threshold: ',thres)
    l_counter=1 # used to form the index of the correct layer. We need layers 0,3,6.
    for fl in filters:
        layer_name=lm.get_layer(name='conv2d_'+str(l_counter))
        index_list=[]
        for i in range(thres):
            index_list.append(i)
        lm=delete_channels(lm,layer_name,index_list)#Function of keras surgeon library to prune channels 
        layer_name.trainable=False #every processed layer is set as non-trainable and the rest network is retrained. 
        lm.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.Adam(),metrics=['accuracy'])
        split_data(lm,train_data,train_labels,batch_size,epochs)
        l_counter+=1
        
    for layer in lm.layers: #when pruning of all convolutional layers is finished the network is restored to trainable.
        layer.trainable=True
        lm.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.Adam(),metrics=['accuracy'])
        
    lm.save('Prune_fmaps_'+str(thres)+'_model_1.h5py')
    print('Pruning is completed')    
    count_weights('Prune_fmaps_'+str(thres)+'_model_1.h5py',test_data,test_labels)

def count_weights(model_name,dataset,labels):
    model=load_model(model_name)
    test_eval=model.evaluate(dataset,labels,verbose=0)
    print('Test loss for sparse model : ', test_eval[0])
    print('Test accuracy for sparse model : ',test_eval[1])


##########################################################################################################################################
train_labels=create_train_label()
test_labels=create_test_label()

train_data=train_dataset() 
test_data=test_dataset()

train_data.resize(len(train_data),250,16,1)
test_data.resize(len(test_data),250,16,1)
print('Shape of labels: ',test_labels.shape, train_labels.shape)
print('Shape of data: ',test_data.shape,train_data.shape,'\n')

batch_size=100
epochs=10

#number of filter we want to prune.
#Should be smaller or equal to the number of filters. For models 1,2,5 maximum value is set to 15. For models 3,4 maximum value is set to 7.
sp=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] 
for sp_coef in sp:
    lm=load_model(r'C:\Users\vaggelis Dalianis\Desktop\Thesis\MyDataset\test dataset\inhaler_model_1.h5py')     
    index_of_filters=sort_filters(lm)
    print('Sparsity Coefficient: ',sp_coef)
    prune_filters(index_of_filters,sp_coef,lm,test_data,test_labels,train_data,train_labels,batch_size,epochs)
