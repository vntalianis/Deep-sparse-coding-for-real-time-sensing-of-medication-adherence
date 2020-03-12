import os
import keras
import librosa
import numpy as np

from sklearn.cluster import KMeans,MiniBatchKMeans

from keras.models import load_model
from keras.utils import to_categorical
from sklearn.model_selection import ShuffleSplit

def extract_features(filename):
    X,sample_rate=librosa.load(filename,sr=8000) #files with sampling rate=44100 are downsampled,files of 44KB
    return X

def test_dataset():
    print('Creating test dataset.')
    empty_mat=np.empty([0,250,16])#250x16 for sr=8000 else 2205x10
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

def KMEANS_for_convolution(model,clusters):
    #Function that gathers the weights through the channels.
    #The parameters passed are a pre-trained model and clusters which is the number of different representative values kmeans should produce.
    for layer in model.layers[0:7]:
        if layer.get_weights()!=[]:
            weights=layer.get_weights()[0]
            bias=layer.get_weights()[1]
            parameter_list=[]
            #4 for loops to iterate through the weight matrix.
            #kmeans is executed in channels to produce same kernels and consequnetly same feature maps 
            for i in range(weights.shape[0]):#iteration through channels
                for j in range(weights.shape[1]):
                    for k in range(weights.shape[2]):
                        my_list=[] #list with the weights through the channel axis 
                        for l in range(weights.shape[3]):
                            my_list.append(weights[i][j][k][l])                
                        new_weight_list=clustering(my_list,clusters)
                        
                        for w in range(len(new_weight_list)):
                            weights[i][j][k][w]=new_weight_list[w]                
                        
            #load the new weights to the model
            parameter_list.append(weights)
            parameter_list.append(bias)
            layer.set_weights(parameter_list)
    print('Convolutional layers are processed.')
    return model
                            
def KMEANS_for_fully_connected(model,clusters):
    #Function that executes kmeans algorithm on fully connected layer.
    #The arguments passed in the function is a pre-trained model and a variables showing
    #how mo=any values kmeans should produce
    #The weight matrix is from a 2d m*n shape to a vector of mn*1 
    for layer in model.layers[8:13]:
        if layer.get_weights()!=[]:
            weights=layer.get_weights()[0]
            bias=layer.get_weights()[1]
            parameter_list=[]
            my_list=[] #list with the weights that belong in a layer
            for i in range(weights.shape[0]):                
                for k in range(weights.shape[1]):
                    my_list.append(weights[i][k])
            my_list=np.resize(my_list,(len(my_list),1))#is a copy of my_list with array form

            kmeans=MiniBatchKMeans(n_clusters=clusters,random_state=10,batch_size=256).fit(my_list)
            centers=kmeans.cluster_centers_ #the codebook as described in the literature of quantization with kmeans
            
            for i in range(weights.shape[0]):
                for j in range(weights.shape[1]):
                    w=np.resize(weights[i][j],(1,1))
                    predictions=kmeans.predict(w) #returns the index of the closest code in the codebook
                    weights[i][j]=centers[predictions][0]#replace the old weights with the new values produces=d by kmeans
                    
            parameter_list.append(weights)
            parameter_list.append(bias)
            layer.set_weights(parameter_list)
    print('Centers are computed.')
    return model

def clustering(weight_list,clusters):
    #Function that executes the kmeans algorithms on a given space.
    #Weight_list contains the weights of a layer. For convolutional layers kmeans is performed on channels axis
    weight_list=np.reshape(weight_list,(len(weight_list),1))
    kmeans=KMeans(n_clusters=clusters).fit(weight_list)
    predictions=kmeans.predict(weight_list)
    centers=kmeans.cluster_centers_
    for j in range(len(predictions)):
        weight_list[j]=centers[predictions[j]][0]
    return weight_list

def calculate_accuracy(model_name,dataset,labels):
    model=load_model(model_name)
    test_eval=model.evaluate(dataset,labels,verbose=0)
    print('Test loss for sparse model : ', test_eval[0])
    print('Test accuracy for sparse model : ',test_eval[1],'\n')

path1='C:/Users/vaggelis Dalianis/Desktop/Thesis/MyDataset/test dataset/'

model=['inhaler_model_1.h5py']
       #'inhaler_model_2.h5py'
       #'inhaler_model_3.h5py'
       #'inhaler_model_4.h5py',
       #'inhaler_device_model_v2.h5py']


test_labels=create_test_label()
test_data=test_dataset()
test_data.resize(len(test_data),250,16,1)

#clusters should be smaller or equal to the initial number of weights. For convolutional layers for models 1,2,v2 maximum clusters are 16 and for the others 8.
#clusters for quantization in each layers. These values are tested for quantizing fully connected layer.
c_conv=[1,4,8,16,24,32,40,52,64,72,96,112,128]
for dense_model in model:
    print('Quantizing model:', dense_model)
    for clusters_conv in c_conv:
        loaded_dense_model=load_model(path1+dense_model)
        print('Clusters :',clusters_conv)
        ##my_model=KMEANS_for_convolution(loaded_dense_model,clusters_conv)
        my_model=KMEANS_for_fully_connected(loaded_dense_model,clusters_conv)
        my_model.save('pruned_scalar_vq_d='+str(clusters_conv)+'_'+dense_model)
        calculate_accuracy('pruned_scalar_vq_d='+str(clusters_conv)+'_'+dense_model,test_data,test_labels)
