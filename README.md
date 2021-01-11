

# Deep CNN Sparse Coding for Real Time Inhaler Sounds Classification


Ntalianis, V., Fakotakis, N. D., Nousias, S., Lalos, A. S., Birbas, M., Zacharaki, E. I., & Moustakas, K. (2020). Deep CNN Sparse Coding for Real Time Inhaler Sounds Classification. Sensors, 20(8), 2363.


## Introduction
Effective management of chronic constrictive pulmonary conditions lies in proper and timely administration of medication. As a series of studies indicates, medication adherence can effectively be monitored by successfully identifying actions performed by patients during inhaler usage. This study focuses on the recognition of inhaler audio events during usage of pressurized metered dose inhalers (pMDI). Aiming at real-time performance, we investigate deep sparse coding techniques including convolutional filter pruning, scalar pruning and vector quantization, for different convolutional neural network (CNN) architectures. The recognition performance has been assessed on three healthy subjects following both within and across subjects modeling strategies. The selected CNN architecture classified drug actuation, inhalation and exhalation events, with 100%, 92.6% and 97.9% accuracy, respectively, when assessed in a leave-one-subject-out cross-validation setting. Moreover, sparse coding of the same architecture with an increasing compression rate from 1 to 7 resulted in only a small decrease in classification accuracy (from 95.7% to 94.5%), obtained by random (subject-agnostic) cross-validation. A more thorough assessment on a larger dataset, including recordings of subjects with multiple respiratory disease manifestations, is still required in order to better evaluate the method’s generalization ability and robustness.


![Overall architecture](https://raw.githubusercontent.com/vntalianis/Deep-sparse-coding-for-real-time-sensing-of-medication-adherence/master/images/sensors-20-02363-g002-550.jpg)


## Dataset
Generic format:
```
Filename, Class, Sample index at the beginning of the acoustic event, Sample index at the end of the acoustic event

```

Example:

```
rec2018-01-22_17h41m33.475s.wav,Exhale,6015,17437
rec2018-01-22_17h41m33.475s.wav,Inhale,20840,31655
rec2018-01-22_17h41m33.475s.wav,Drug,31898,37610
rec2018-01-22_17h41m33.475s.wav,Exhale,43686,59969
rec2018-01-22_17h41m49.809s.wav,Inhale,5043,17316
rec2018-01-22_17h41m49.809s.wav,Drug,18288,24364
rec2018-01-22_17h41m49.809s.wav,Exhale,31412,46724
rec2018-01-22_17h42m07.718s.wav,Exhale,303,9782
rec2018-01-22_17h42m07.718s.wav,Inhale,16951,28010
```

## Configuration

Set the proper location for trained model and data path in config.py

```
batch_size = 64
epochs = 40
classes=['Drug','Exhale','Inhale','Noise']
num_classes = len(classes)
trainedModel = './trained_models/inhaler_model_5.h5py'
fromScratch=False
doStore=False
path="./data/"
```

## Training

### Training and testing with 10-fold cross validation
```

python train_eval_ten_fold_cross_validation.py

```

### Training and testing with a single fold

```

python train_eval_single_fold.py

```

### Pruning (filter sort)

```

python train_eval_single_fold.py

```

### Pruning (thresholded) with retraining

```

python train_eval_pruning_with_retraining.py

```

### Pruning (thresholded) without retraining

```

python train_eval_pruning_without_retraining.py

```

### Product quantization

```

python train_eval_product_quantization.py

```


## Citation

```
@article{ntalianis2020deep,
  title={Deep CNN Sparse Coding for Real Time Inhaler Sounds Classification},
  author={Ntalianis, Vaggelis and Fakotakis, Nikos Dimitris and Nousias, Stavros and Lalos, Aris S and Birbas, Michael and Zacharaki, Evangelia I and Moustakas, Konstantinos},
  journal={Sensors},
  volume={20},
  number={8},
  pages={2363},
  year={2020},
  publisher={Multidisciplinary Digital Publishing Institute}
}
```