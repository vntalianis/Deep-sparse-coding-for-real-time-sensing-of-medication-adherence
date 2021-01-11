from keras.models import Sequential,Model,load_model,save_model
from keras.layers import Dense, Dropout, LSTM, BatchNormalization,Flatten,Conv2D,MaxPooling2D,Input,LeakyReLU,ReLU,Softmax
from keras.callbacks import TensorBoard
from keras.callbacks import ModelCheckpoint
from keras.losses import categorical_crossentropy


##CNN Architecture
def build_model(x_shape,num_classes):
    inputs = Input(shape=x_shape)
    x = Conv2D(16,kernel_size=(5,5),input_shape=(250,16,1),padding='same',use_bias=True)(inputs)
    #x = BatchNormalization()(x)
    x = LeakyReLU(alpha=0.2)(x)
    x = MaxPooling2D((2, 2), padding='same')(x)
    x= Dropout(0.2)(x)
    x= Conv2D(2*16, (5,5), padding='same',use_bias=True)(x)
    #x = BatchNormalization()(x)
    x = LeakyReLU(alpha=0.2)(x)
    x= MaxPooling2D(pool_size=(2,2),padding='same')(x)
    x= Dropout(0.1)(x)
    x= Conv2D(4*16, (5,5),padding='same',use_bias=True)(x)
    #x = BatchNormalization()(x)
    x = LeakyReLU(alpha=0.2)(x)
    x= MaxPooling2D(pool_size=(2,2),padding='same')(x)
    x= Flatten()(x)
    x= Dense(64)(x)
    x=ReLU()(x)
    x = Dense(32)(x)
    x = ReLU()(x)
    x = Dense(16)(x)
    x = ReLU()(x)
    x=Dense(num_classes)(x)
    predictions = Softmax()(x)
    model = Model(inputs=inputs, outputs=predictions)
    return model