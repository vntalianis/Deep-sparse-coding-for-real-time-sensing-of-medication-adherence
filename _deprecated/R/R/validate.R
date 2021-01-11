# libraries
rm(list = ls())
suppressWarnings(suppressMessages(library("e1071")))
suppressWarnings(suppressMessages(library("adabag")))
suppressWarnings(suppressMessages(library("randomForest")))
suppressWarnings(suppressMessages(library("caret")))
suppressWarnings(suppressMessages(library("tuneR")))
suppressWarnings(suppressMessages(library("jsonlite")))
suppressWarnings(suppressMessages(library("ggplot2")))
suppressWarnings(suppressMessages(library("spate")))
suppressWarnings(suppressMessages(library("dtt")))
suppressWarnings(suppressMessages(library("Rwave")))
suppressWarnings(suppressMessages(library("foreach")))
suppressWarnings(suppressMessages(library("doParallel")))


pak <-
  c("e1071",
    "adabag",
    "randomForest",
    "caret",
    "tuneR",
    "spate",
    "dtt",
    "Rwave")

source("functions.R")
options(warn = -1)
setwd("E:/Dropbox/_GroundWork/Development/Inhaler")



DFID <- "f1_cwt_normalized"
path <- "AudioAnnotator/sources/_initial_1_F1"
DFFnm1 <- paste(path, "/", "DF_", DFID, ".csv", sep = "")
DF1 <- read.csv(file = DFFnm1, header = FALSE)

DFID <- "g1_cwt_normalized"
path <- "AudioAnnotator/sources/_gerasimos_G1"
DFFnm2 <- paste(path, "/", "DF_", DFID, ".csv", sep = "")
DF2 <- read.csv(file = DFFnm2, header = FALSE)

DFID <- "a1_cwt_normalized"
path <- "AudioAnnotator/sources/_aggeliki_A1"
DFFnm3 <- paste(path, "/", "DF_", DFID, ".csv", sep = "")
DF3 <- read.csv(file = DFFnm3, header = FALSE)

DFID <- "cat1_drug_cwt_normalized"
path <- "AudioAnnotator/sources/_Cat1"
DFFnm4 <- paste(path, "/", "DF_", DFID, ".csv", sep = "")
DF4 <- read.csv(file = DFFnm4, header = FALSE)

DFID <- "cat1_noise_cwt_normalized"
path <- "AudioAnnotator/sources/_Cat1"
DFFnm5 <- paste(path, "/", "DF_", DFID, ".csv", sep = "")
DF5 <- read.csv(file = DFFnm5, header = FALSE)

DFID <- "cat1_exhale_cwt_normalized"
path <- "AudioAnnotator/sources/_Cat1"
DFFnm6 <- paste(path, "/", "DF_", DFID, ".csv", sep = "")
DF6 <- read.csv(file = DFFnm6, header = FALSE)


DFID <- "uploads_U1_noise_cwt_normalized"
path <- "AudioAnnotator/sources/_uploads_U1"
DFFnm7 <- paste(path, "/", "DF_", DFID, ".csv", sep = "")
DF7 <- read.csv(file = DFFnm7, header = FALSE)


DFID<-"_uploads_2018_05_17-22_drug_cwt_normalized"
path <- "AudioAnnotator/sources/_uploads_2018_05_17-22"
DFFnm8 <- paste(path,"/","DF_",DFID,".csv", sep = "")
DF8 <- read.csv(file = DFFnm8, header = FALSE)


DFID<-"_uploads_2018_05_22_drug_cwt_normalized"
path <- "AudioAnnotator/sources/_uploads_2018_05_22_drug"
DFFnm9 <- paste(path,"/","DF_",DFID,".csv", sep = "")
DF9 <- read.csv(file = DFFnm9, header = FALSE)





 DFA <- rbind(DF1, DF5, DF7,DF8,DF9)

 #DFB <- rbind(DF1,DF2, DF3,DF4, DF5,DF6, DF7)
 DFB <- rbind(DF2, DF3,DF4, DF5,DF6, DF7)

 DFC <- rbind(DF1, DF2, DF3,DF4, DF5,DF6, DF7,DF8,DF9)

 DF<-DFA
 
DF <- as.data.frame(DF)
DF <- DF[complete.cases(DF), ]

DF <- DF[sample(nrow(DF)),]
DF <- DF[sample(nrow(DF)),]
DF <- DF[sample(nrow(DF)),]
DF <- DF[sample(nrow(DF)),]

numberOfFolds<-10
#Create 10 equally size folds
folds <- cut(seq(1,nrow(DF)),breaks=numberOfFolds,labels=FALSE)

reference<-DF$V1
prediction<-vector(mode="numeric", length=0)

for(i in 1:numberOfFolds){
  
  testIndexes <- which(folds==i,arr.ind=TRUE)
  testData <- DF[testIndexes, ]
  testData <-testData[2:ncol(testData)]
  trainData <- DF[-testIndexes, ]
  trainData$V1=factor(trainData$V1,levels=1:4)
  
  rf=randomForest(V1~.,trainData)
  pred=predict(rf,testData)
  prediction<-c(prediction,pred)
  
  
}


confMat<-confusionMatrix(prediction,reference)
print(confMat)

