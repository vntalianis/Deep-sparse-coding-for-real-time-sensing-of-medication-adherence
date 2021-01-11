# libraries
library("e1071");
library("adabag");
library("randomForest");
library("gmum.r");
library("proxy");
library("FNN");
rm(list = ls());
options(warn=-1)
setwd("E:/Dropbox/_Publications/IEEE_Sensors_Material/Matlab")


typesFeat<-c('mfcc','spect','cept');
classifiers<-c('SVM','Random Forest','ADABoost');




features<-40;
sampleIds<-c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
#sampleIds<-c(1,2,3);
#classifier=2
neighboors=1
patients<-c('Patient-1','Patient-2');
#patients<-c('Patient-1');



for (type in typesFeat){
  for (classifier in 1:3){
    if (type=='mfcc'){curclass<-'MFCC'}
    if (type=='spect'){curclass<-'Spectrogram'}
    if (type=='cept'){curclass<-'Cepstogram'}
    
    classificationAccuracyIndex<-1;
    classificationAccuracyFinal<-list()

for (patient in patients){
  for (currentRFRecord in sampleIds){
  
    relevanceFeedbackDataIndex<-1;
    relevanceFeedbackData<-list()
    
    relevantDatasetIndex<-1;
    relevantDataset<-list()
    
    testId=sampleIds[currentRFRecord];
    percentage<- vector(mode="integer", length=5);

    inds1<- vector(mode="integer", length=0);
    inds2<- vector(mode="integer", length=0);
    inds3<- vector(mode="integer", length=0);
    inds4<- vector(mode="integer", length=0);
    for (sampleIndex in sampleIds[-testId]){
      print(paste(c('Current sample is ',currentRFRecord,' ',sampleIndex),collapse=" "))
      
      
      sampleId<-sampleIds[sampleIndex];
      

      train_file=paste(c('Results','/0-00/',type,'/','all.csv'), collapse="")
      trainData=read.csv(train_file,header=F)
      
      class1<-trainData[trainData$V1==1,]
      class2<-trainData[trainData$V1==2,]
      class3<-trainData[trainData$V1==3,]
      class4<-trainData[trainData$V1==4,]
      
      patient_feedback_file=paste(c('RecorderSounds','/',patient,'/',sampleId,'/',type,'.csv'), collapse="")
      patient_feedback_data=read.csv(patient_feedback_file,header=F)
      patient_feedback_data <-patient_feedback_data[1:(features+1)]
      patient_feedback_annotation_file=paste(c('RecorderSounds/',patient,'/','relevanceFeedback.csv'), collapse="")
      
      patient_feedback_annotation_data=read.csv(patient_feedback_annotation_file,header=F)
      patient_feedback_annotation_data_transpose<-t(patient_feedback_annotation_data)
      relevanceFeedbackAnnotation=patient_feedback_annotation_data_transpose[,sampleId]
      patient_feedback_data[,1]=relevanceFeedbackAnnotation
      
      relevanceFeedback=patient_feedback_data
      
      for (i in 1:nrow(relevanceFeedback)){
        if(relevanceFeedback[i,1]==1){
          sample<-relevanceFeedback[i,-1]
          curinds<-knnx.index(class1[,-1],sample, k=neighboors)
          inds1<-cbind(inds1,curinds)
        }
        if(relevanceFeedback[i,1]==2){
          sample<-relevanceFeedback[i,-1]
          curinds<-knnx.index(class2[,-1],sample, k=neighboors)
          inds2<-cbind(inds2,curinds)
        }
        if(relevanceFeedback[i,1]==3){
          sample<-relevanceFeedback[i,-1]
          curinds<-knnx.index(class3[,-1],sample, k=neighboors)
          inds3<-cbind(inds3,curinds)
        }
        if(relevanceFeedback[i,1]==4){
          sample<-relevanceFeedback[i,-1]
          curinds<-knnx.index(class4[,-1],sample, k=neighboors)
          inds4<-cbind(inds4,curinds)
        }
      }
      inds1<-unique(inds1)
      inds2<-unique(inds2)
      inds3<-unique(inds3)
      inds4<-unique(inds4)
      
      idealLength<-pmin(length(inds2),length(inds3),length(inds4))
      inds2 <- inds2[,sample(1:length(inds2), idealLength,replace=FALSE)]
      inds3 <- inds3[,sample(1:length(inds3), idealLength,replace=FALSE)]
      inds4 <- inds4[,sample(1:length(inds4), idealLength,replace=FALSE)]
      
      relatedEntries<-rbind(trainData[trainData$V1==1,][inds1,],trainData[trainData$V1==2,][inds2,],trainData[trainData$V1==3,][inds3,],trainData[trainData$V1==4,][inds4,]);
      
      relevantDataset[[relevantDatasetIndex]]<-relatedEntries;
      relevantDatasetIndex<-relevantDatasetIndex+1
      
      relevanceFeedbackData[[relevanceFeedbackDataIndex]]<-patient_feedback_data
      relevanceFeedbackDataIndex<-relevanceFeedbackDataIndex+1
    }
    

    ############################################################################################
    ############################################################################################
    ###############################   Testing  ############################
    ############################################################################################
    ############################################################################################
    
    
    
    sampleId<-sampleIds[testId]
    test_file=paste(c('RecorderSounds','/',patient,'/',sampleId,'/',type,'.csv'), collapse="")
    testData=read.csv(test_file,header=F)
    testData <-testData[1:(features+1)]
    relevanceFeedbackAnnotation=patient_feedback_annotation_data_transpose[,sampleId]
    testData[,1]=relevanceFeedbackAnnotation
    
    for (trial in 1:length(sampleIds[-testId])){
      print(paste(c('Current trial is ',currentRFRecord,' ',trial),collapse=" "))
      
      
      
      if(trial==1){
        newTrainData<-trainData
        #newTrainData<-relevantDataset[[1]];  
        #newTrainData=rbind(relevanceFeedbackData[[1]],relevantDataset[[1]])
      }
      
      if(trial==2){
        #newTrainData<-relevantDataset[[2]];  
        newTrainData<-rbind(relevanceFeedbackData[[1]],relevanceFeedbackData[[2]],relevantDataset[[2]])
      }
      
      if(trial>2){
        newTrainData<-relevantDataset[[trial]]
        for (counter in 2:trial){
          newTrainData=rbind(relevanceFeedbackData[[counter]],newTrainData) 
        } 
      }
      
      
      
      
      newTrainData$V1=factor(newTrainData$V1,levels=1:4)
      if (classifier==1)
      {
        sv=svm(V1~.,newTrainData,kernel="radial")
        pred=predict(sv,testData)
      }
      if (classifier==2)
      {
        rf=randomForest(V1~.,newTrainData)
        pred=predict(rf,testData)
      }
      if (classifier==3)
      {
        ab=boosting(V1~.,newTrainData,coeflearn="Zhu")
        pred=predict(ab,testData)$class
        
      }
      predictedValues<-matrix(as.numeric(pred))
      initialValues=testData[1]
      
      diff<-predictedValues-initialValues
      zeros<-sum(diff == 0)
      nonzeros<-sum(diff != 0)
      successPercentage<-zeros/(zeros+nonzeros)
      percentage[trial]=successPercentage
      
      
    }
    classificationAccuracyFinal[[classificationAccuracyIndex]]<-percentage
    classificationAccuracyIndex<-classificationAccuracyIndex+1;
  
    
    
    
    
    
    
    }
}


boxplotdata<-do.call(rbind.data.frame, classificationAccuracyFinal)
#boxplotdata<-boxplotdata[-1]
colnames(boxplotdata) <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17");
boxplot(boxplotdata ,lwd = 2)
#geom_boxplot(lwd=3)
title(paste(c('Relevance feedback of ',curclass,' based features classified with ',classifiers[classifier]), collapse=""))
}}
