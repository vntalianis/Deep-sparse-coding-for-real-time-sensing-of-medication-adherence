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



type<-'spect'
features<-40;
sampleIds<-c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
#sampleIds<-c(1,2,3,4,5,6);
classifier=1
neighboors=5
patients<-c('Patient-1','Patient-2');
#patients<-c('Patient-2');
classificationAccuracyIndex<-1;
classificationAccuracyFinal<-list()
for (patient in patients){
  for (vcd in sampleIds){
    relevanceFeedbackDataIndex<-1;
    relevanceFeedbackData<-list()
    
    
    testId=sampleIds[vcd];
    percentage<- vector(mode="integer", length=5);
    
    inds1<- vector(mode="integer", length=0);
    inds2<- vector(mode="integer", length=0);
    inds3<- vector(mode="integer", length=0);
    inds4<- vector(mode="integer", length=0);
    
    
    for (sampleIndex in sampleIds[-testId]){
      sampleId<-sampleIds[sampleIndex];
      train_file=paste(c('Results','/0-00/',type,'/','all.csv'), collapse="")
      trainData=read.csv(train_file,header=F)
      test_file=paste(c('RecorderSounds','/',patient,'/',sampleId,'/',type,'.csv'), collapse="")
      testData=read.csv(test_file,header=F)
      testData <-testData[1:(features+1)]
      relfile=paste(c('RecorderSounds/',patient,'/','relevanceFeedback.csv'), collapse="")
      userRel=read.csv(relfile,header=F)
      userRelT<-t(userRel)
      relevanceFeedbackAnnotation=userRelT[,sampleId]
      testData[1]=relevanceFeedbackAnnotation
      relevanceFeedback=testData
      
      ############################
      ############################
      ##Relevance feedback process
      ############################
      ############################
      
      
      class1<-trainData[trainData$V1==1,]
      class2<-trainData[trainData$V1==2,]
      class3<-trainData[trainData$V1==3,]
      class4<-trainData[trainData$V1==4,]
      
      
      
      
      
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
      

      test_file=paste(c('RecorderSounds','/',patient,'/',sampleId,'/',type,'.csv'), collapse="")
      testData=read.csv(test_file,header=F)
      testData <-testData[1:ncol(trainData)]
      testData[1]=relevanceFeedbackAnnotation
      
      relevanceFeedbackData[[relevanceFeedbackDataIndex]]<-testData
      relevanceFeedbackDataIndex<-relevanceFeedbackDataIndex+1;
    }
    
    
    
    
    ############################
    ############################
    ##Test relevance feedback
    ############################
    ############################
    
    
    
    
    
    
    
    for (attempr in 1:length(sampleIds[-testId])){
      

   
      sampleId<-sampleIds[testId]

      train_file=paste(c('Results','/0-00/',type,'/','all.csv'), collapse="")
      trainData=read.csv(train_file,header=F)
      
      
      
      newTrainData=rbind(trainData[trainData$V1==1,][inds1,],trainData[trainData$V1==2,][inds2,],trainData[trainData$V1==3,][inds3,],trainData[trainData$V1==4,][inds4,]);


      if(attempr==1){
        newTrainData=trainData;  
      }else{ #else
        for (attt in 2:attempr){
          newTrainData=rbind(relevanceFeedbackData[[attt-1]],newTrainData) 
        } 
        
      }
      
      
      
      newTrainData$V1=factor(newTrainData$V1,levels=1:4)
      
      test_file=paste(c('RecorderSounds','/',patient,'/',sampleId,'/',type,'.csv'), collapse="")
      testData=read.csv(test_file,header=F)
      testData <-testData[1:ncol(newTrainData)]
      
      if (classifier==1)
      {
        sv=svm(V1~.,newTrainData,kernel="radial")
        pred=predict(sv,testData)
        predictedValues<-matrix(as.numeric(pred))
      }
      if (classifier==2)
      {
        rf=randomForest(V1~.,newTrainData)
        pred=predict(rf,testData)
        predictedValues<-matrix(as.numeric(pred))
      }
      if (classifier==3)
      {
        ab=boosting(V1~.,newTrainData,coeflearn="Zhu")
        pred=predict(ab,testData)$class
        predictedValues<-matrix(as.numeric(pred))
      }
      testData[1]=predictedValues
      initialValues=userRel[sampleId,]
      diff<-predictedValues-initialValues
      
      zeros<-sum(diff == 0)
      nonzeros<-sum(diff != 0)
      successPercentage<-zeros/(zeros+nonzeros)
      
      percentage[attempr]=successPercentage
    }
    
    
    classificationAccuracyFinal[[classificationAccuracyIndex]]<-percentage
    classificationAccuracyIndex<-classificationAccuracyIndex+1;

  }
  
  

  
}


boxplotdata<-do.call(rbind.data.frame, classificationAccuracyFinal)
boxplotdata<-boxplotdata[-1]
colnames(boxplotdata) <- c("2","3","4","5") 
#,"7","8","9","10","11","12","13","14","15","16","17");
boxplot(boxplotdata)
