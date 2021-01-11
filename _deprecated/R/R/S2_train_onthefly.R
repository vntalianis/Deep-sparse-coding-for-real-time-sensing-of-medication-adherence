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


pak<-c("e1071","adabag","randomForest","caret","tuneR","spate","dtt","Rwave")

source("functions.R")
options(warn = -1)
setwd("E:/Dropbox/_GroundWork/Inhaler")


# path <- "Input"
# annotation <- read.csv('annotation.csv')

# DFID<-"f1_cwt_normalized"
# path <- "AudioAnnotator/sources/_initial_1_F1"
# annotation <- read.csv('AudioAnnotator/sources/_initial_1_F1/annotation_f1_all.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"g1_cwt_normalized"
# path <- "AudioAnnotator/sources/_gerasimos_G1"
# annotation <- read.csv('AudioAnnotator/sources/_gerasimos_G1/annotation_g1_all.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"a1_cwt_normalized"
# path <- "AudioAnnotator/sources/_aggeliki_A1"
# annotation <- read.csv('AudioAnnotator/sources/_aggeliki_A1/annotation_a1_all.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"cat1_drug_cwt_normalized"
# path <- "AudioAnnotator/sources/_Cat1"
# annotation <- read.csv('AudioAnnotator/sources/_Cat1/annotation_cat1_drug.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"cat1_noise_cwt_normalized"
# path <- "AudioAnnotator/sources/_Cat1"
# annotation <- read.csv('AudioAnnotator/sources/_Cat1/annotation_Cat1_noise.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"cat1_exhale_cwt_normalized"
# path <- "AudioAnnotator/sources/_Cat1"
# annotation <- read.csv('AudioAnnotator/sources/_Cat1/annotation_cat1_exhale.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"uploads_U1_noise_cwt_normalized"
# path <- "AudioAnnotator/sources/_uploads_U1"
# annotation <- read.csv('AudioAnnotator/sources/_uploads_U1/annotation_spacer_u1_noise.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"_uploads_2018_05_17-22_drug_cwt_normalized"
# path <- "AudioAnnotator/sources/_uploads_2018_05_17-22"
# annotation <- read.csv('AudioAnnotator/sources/_uploads_2018_05_17-22/annotation_uploads_2018_05_17-22_drug.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")

# DFID<-"_uploads_2018_05_22_drug_cwt_normalized"
# path <- "AudioAnnotator/sources/_uploads_2018_05_22_drug"
# annotation <- read.csv('AudioAnnotator/sources/_uploads_2018_05_22_drug/annotation_2018_05_22_drug.csv')
# DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")


DFID<-"_uploads_2018_05_22_drug_cwt_normalized"
path <- "AudioAnnotator/sources/_uploads_2018_05_22_drug"
annotation <- read.csv('AudioAnnotator/sources/_uploads_2018_05_22_drug/annotation_2018_05_22_drug.csv')
DFFnm <- paste(path,"/","DF_",DFID,".csv", sep = "")


doNormalize<-TRUE

wlen <- 512
h <- wlen / 4
#fnms <- list.files(path)


#f <- file("DF.csv", open="w")
#truncate(f)
#cl <- makeCluster(2)
#registerDoParallel(cl)
#stopCluster(cl)
#foreach(i=1:nrow(annotation),.packages=pak) %dopar% {





for (i in (1:nrow(annotation))) {
  print( paste("Line#:", i, "out of ",nrow(annotation), sep = "") )
 
  fnm <- toString(annotation[i, 1])
  class <- toString(annotation[i, 2])
  xd1 <- annotation[i, 3]
  xd2 <- annotation[i, 4]
  
  filename <- paste(path, "/", fnm, sep = "")
  c <-
    readWave(
      filename,
      from = 1,
      to = Inf,
      header = FALSE,
      toWaveMC = TRUE
    )
  #X <- c@.Data
  #X<-X/(2^(c@bit-1))
  
  X <- c@.Data
  X<-X/(2^(c@bit-1))
  if(doNormalize){
  X<-X/(sd(X))
  }
  
  
  #X<-X/max(X)
  #X<-(length(X)/Fs)*X/sum(X)
  #X<-X/sqrt((sum(X^2)/length(X)))
  #X<-X/max(X)
  #X<-0.5*X
  
  Fs<-c@samp.rate
  
  
  Xin <- X
  S <- spect(Xin)
  C <- cepst(Xin)
  M <- mel(Xin)
  Z <- zcr(Xin)
  CWTMat<-cwtrfrm(Xin)
  CWTMat<-t(CWTMat)
  
  a <- floor(xd1 / h)
  b <- floor((xd2-wlen) / h)
  if ((a != b)&&(a>0)) {
    SFeatures <- pextractor(S, a, b)
    CFeatures <- pextractor(C, a, b)
    MFeatures <- pextractor(M, a, b)
    ZFeature <- sextractor(Z, a, b)
    CWTFeature<- pextractor(CWTMat, a, b)
    
    
    
    ###Plots
    #plot(as.vector(Xin[floor(length(X)*xd1):floor(length(X)*xd2)]))
    #plot(as.vector(S2))
    #plot(as.vector(C2))
    #image((t(S)))
    #image((t(C)))
    #image((t(M)))
    #image(t(Z))
    
    
    classIndex = 1
    if (class == "Drug") {
      classIndex = 1
    }
    if (class == "Exhale") {
      classIndex = 2
    }
    if (class == "Inhale") {
      classIndex = 3
    }
    if (class == "Noise") {
      classIndex = 4
    }
    
    Features = c(
      classIndex,
      as.vector(CWTFeature),
      as.vector(SFeatures),
      as.vector(CFeatures),
      as.vector(MFeatures),
      ZFeature
    )
    Features <- as.matrix(Features)
    
    if (i==1){
    write.table((t(Features)), file = DFFnm, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE)
    }
    else{
      write.table((t(Features)), file = DFFnm, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE)
    }
      
    # if (!exists("DF")) {
    #   DF <- as.data.frame(t(Features))
    # } else{
    #   DF <- rbind(DF, t(Features))
    # }
    
    
  }
}

DF <- read.csv(file=DFFnm,header=FALSE)


trainData<-as.data.frame(DF)
trainData<-trainData[complete.cases(trainData),]
trainData$V1 = factor(trainData$V1, levels = 1:4)



rf = randomForest(V1 ~ ., trainData)
save(rf,file = paste(path,"/","inhalerRF_", DFID, ".RData", sep = ""))

ab=boosting(V1~.,trainData,coeflearn="Zhu")
save(ab,file = paste(path,"/","inhalerAB_", DFID, ".RData", sep = ""))

