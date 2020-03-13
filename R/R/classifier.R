# libraries
suppressWarnings(suppressMessages(library("e1071")))
suppressWarnings(suppressMessages(library("adabag")))
suppressWarnings(suppressMessages(library("randomForest")))
suppressWarnings(suppressMessages(library("caret")))


# input arguments, see how to combine with php
rm(list = ls());
options(warn=-1)
setwd("E:/Dropbox/_Publications/IEEE_Sensors_Material/Matlab/R")


args = commandArgs(trailingOnly=TRUE)

test_file="testfile.csv"



testData=read.csv(test_file,header=F)

train_file="trainfile.csv"

trainData=read.csv(train_file,header=F)
trainData$V1=factor(trainData$V1,levels=1:4)


if(is.na(args[1])){
  j=1
  
} else {
  
  j=args[1];
}

#trainData<-as.matrix(trainData)
#testData<-as.matrix(testData)
#j=args[1]
#for (j in 1:3){
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
predictedValues<-matrix(as.numeric(pred))
initialValues<-testData[1]
initialValues<-as.matrix(initialValues)
#predictedValues<-as.data.frame(predictedValues)



diff<-predictedValues-initialValues
zeros<-sum(diff == 0)
nonzeros<-sum(diff != 0)
successPercentage<-zeros/(zeros+nonzeros)
#print(successPercentage)

ConfMat=confusionMatrix(predictedValues,initialValues);

result=paste(c(zeros,'-',nonzeros), collapse="")

result2=paste(c(ConfMat$table[1,1],'-',ConfMat$table[1,2],'-',ConfMat$table[1,3],'-',ConfMat$table[1,4],'-',ConfMat$table[2,1],'-',ConfMat$table[2,2],'-',ConfMat$table[2,3],'-',ConfMat$table[2,4],'-',ConfMat$table[3,1],'-',ConfMat$table[3,2],'-',ConfMat$table[3,3],'-',ConfMat$table[3,4],'-',ConfMat$table[4,1],'-',ConfMat$table[4,2],'-',ConfMat$table[4,3],'-',ConfMat$table[4,4]), collapse="")

print(result2)




#print(ConfMat$table)
#}
