import numpy as np

batch_size = 64
epochs = 40
classes=['Drug','Exhale','Inhale','Noise']
num_classes = len(classes)
trainedModel = './trained_models/inhaler_model_5.h5py'
fromScratch=False
doStore=False
path="./data/"


np.set_printoptions(formatter={'float': lambda x: "{0:0.3f}".format(x)})