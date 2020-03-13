# libraries
suppressWarnings(suppressMessages(library("e1071")))
suppressWarnings(suppressMessages(library("adabag")))
suppressWarnings(suppressMessages(library("randomForest")))
suppressWarnings(suppressMessages(library("caret")))
suppressWarnings(suppressMessages(library("tuneR")))
rm(list = ls());
options(warn=-1)
setwd("E:/Dropbox/_Publications/IEEE_Sensors_Material/Matlab/R")




# path<-"Final/All";
# dirs<-list.dirs(path)
# dirs<-dirs[2:length(dirs)]
# trainData<- array(0,dim=c(0,41))
# cnt<-0
# for (j in dirs){
# cnt<-cnt+1
# path<-j;
# fnms<-list.files(path)
# i<-fnms[6]
# for (i in fnms){
# filename<-paste(path,"/",i,sep="");
# c<-readWave(filename, from = 1, to = Inf, header = FALSE, toWaveMC = TRUE)
# X<-c@.Data
# X<-as.vector(X)
# X<-X/2^(c@bit-1)
# Fs<-c@samp.rate
# wlen=min(80,floor(length(X)/10))
# dt<-seq(1,length(X),by=Fs/2)
# 
# for (i in 1:length(dt)){
#   Xin<-X[(1+(Fs/2)*(dt[i]-1)):((Fs/2)*(dt[i]))]
#   S<-stft(Xin, win=wlen, inc=wlen/4, coef=40, wtype="hanning.window")
#   Sout<-S$values
#   ssum<-colSums(Sout)
#   ssum<-as.vector(ssum)
# }
# trainData<-rbind(trainData,c(cnt,ssum))
# }
# }
# write.csv(trainData, file = "trainFileSPECT.csv",row.names=FALSE,col.names=FALSE, sep=",")


train_file="trainFileSPECT.csv"
trainData=read.csv(train_file,header = TRUE,sep = ",")
trainData<-as.data.frame(trainData)
trainData$V1=factor(trainData$V1,levels=1:4)

c<-readWave("inhaler-recodring_1509356158_ios.wav", from = 1, to = Inf, header = FALSE, toWaveMC = TRUE)
c<-readWave("inhaler-recodring_1509356013_android.wav", from = 1, to = Inf, header = FALSE, toWaveMC = FALSE)

X<-c@.Data
X<-as.vector(X)
X<-X/2^(c@bit-1)
Fs<-c@samp.rate
wlen=min(80,floor(length(X)/10))
dt<-seq(1,length(X),by=Fs/2)
testData<- array(0,dim=c(0,41))
i=2;
for (i in 1:length(dt)){
  if((dt[i]-1+(Fs/2))<length(X)){
  Xin<-X[dt[i]:(dt[i]-1+(Fs/2))]
  S<-stft(Xin, win=wlen, inc=wlen/4, coef=40, wtype="hanning.window")
  Sout<-S$values
  ssum<-colSums(Sout)
  ssum<-as.vector(ssum)
  testData<-rbind(testData,c(NA,ssum))
  }
}

testData<-as.data.frame(testData)


j=2;



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



