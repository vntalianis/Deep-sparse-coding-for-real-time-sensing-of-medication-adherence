# libraries
library("e1071");
library("adabag");
library("randomForest");
library("gmum.r");
library("proxy");

# input arguments, see how to combine with php
rm(list = ls());
options(warn=-1)
setwd("E:/Dropbox/_Publications/IEEE_Sensors_Material/Matlab")

# reading files, assuming that no headers exist and the first column of train_file is the class

numberOfFeat<-36;
repetitions<-1;
numberOfFolds=10;
#repetitions<-50;
#algslist<-c('SVM','RF','ADA');
algslist<-c('SVM','RF');

train_file="fvfeatures_state4_lambda_1.csv";
traindataAll=read.csv(train_file,header=F)
yourData<-traindataAll

#Randomly shuffle the data
yourData<-yourData[sample(nrow(yourData)),1:numberOfFeat]

#Create 10 equally size folds
folds <- cut(seq(1,nrow(yourData)),breaks=numberOfFolds,labels=FALSE)

#Perform 10 fold cross validation

for(j in 1:length(algslist)){
  zeros<-0
  nonzeros<-0
  for(i in 1:numberOfFolds){
    #Segement your data by fold using the which() function 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- yourData[testIndexes, ]
    testData <-testData[2:ncol(testData)]
    trainData <- yourData[-testIndexes, ]
    trainData$V1=factor(trainData$V1,levels=1:4)
    if (j==1){
      sv=svm(V1~.,trainData,kernel="radial")
      pred=predict(sv,testData)
      
    }
    if (j==2){
      rf=randomForest(V1~.,trainData)
      pred=predict(rf,testData)
    }
    if (j==3){
      ab=boosting(V1~.,trainData,coeflearn="Zhu")
      pred=predict(ab,testData)$class
    }
    #print(pred, quote = FALSE)
    predictedValues<-matrix(as.numeric(pred))
    initialValues<-yourData$V1[testIndexes]
    initialValues<-matrix(as.numeric(initialValues))
    
    diff<-predictedValues-initialValues
    zeros<-zeros+sum(diff == 0)
    nonzeros<-nonzeros+sum(diff != 0)
    
    
    
    
    
    #ConfMat<-confusionMatrix(initialValues,predictedValues);
    #ConfMatTot[[(counter-1)*length(algslist)+1+j-1]]<-ConfMatTot[[(counter-1)*length(algslist)+1+j-1]]+ConfMat$table;
    
    
    
    #Use the test and train data partitions however you desire...
  }
  successPercentage<-zeros/(zeros+nonzeros)
  
  if (j==1){print("SVM:")}
  if (j==2){print("Random forest:")}
  if (j==3){print("Adaboost:")}
  print(successPercentage)
  #ResMat[(counter-1)*length(algslist)+1+j-1,m]=successPercentage;
}
