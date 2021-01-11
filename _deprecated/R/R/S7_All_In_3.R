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
source("E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Src/R/functions.R")
options(warn = -1)
setwd("E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler")


dtset <- c(
  "Data/sources/_a1",
  "Data/sources/_f1",
  "Data/sources/_g1",
  "Data/sources/_type1",
  "Data/sources/_uploads_2",
  "Data/sources/_uploads_3",
  "Data/sources/_uploads_spacer",
  "Data/sources/_sn201807",
  "Data/sources/_sn20180730",
  "Data/sources/_spacer_train_20180821",
  "Data/sources/_noises_1"
)



#feats<-"_SCeMZ"
feats <- "_CwtSCeMZ"
#feats <- "_FG"
#feats <- "_ALLIN"

DFID <- "_f1_dei"
path <- "Data/sources/_f1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d1 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)



DFID <- "_g1_dei"
path <- "Data/sources/_g1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d2 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)




DFID <- "_a1_dei"
path <- "Data/sources/_a1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d3 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)


DFID <- "_type1_d"
path <- "Data/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d4 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)



DFID <- "_type1_e"
path <- "Data/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d5 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)




DFID <- "_type1_n"
path <- "Data/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d6 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)



DFID <- "_uploads_2_d"
path <- "Data/sources/_uploads_2"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d7 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)


DFID <- "_uploads_3_d"
path <- "Data/sources/_uploads_3"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d8 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)




DFID <- "_uploads_spacer_e"
path <- "Data/sources/_uploads_spacer"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d9 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)




DFID <- "_uploads_spacer_n"
path <- "Data/sources/_uploads_spacer"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d10 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)







DFID <- "_sn201807_d"
path <- "Data/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d11 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)

DFID <- "_sn201807_e"
path <- "Data/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d12 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)





DFID <- "_sn201807_i"
path <- "Data/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d13 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)






DFID <- "_sn20180730_d"
path <- "Data/sources/_sn20180730"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d14 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)

DFID <- "_spacer_train_20180821_e"
path <- "Data/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d15 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)

DFID <- "_spacer_train_20180821_i"
path <- "Data/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d16 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)

DFID <- "_spacer_train_20180821_n"
path <- "Data/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d17 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)


DFID <- "_noises_1_n"
path <- "Data/sources/_noises_1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""),header=FALSE)
d18 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm,
  test=annotation,
  train=annotation
)








numberOfFolds<-10
dataset <- list(d1,d2,d3)

testAnnotation<-c()
trainAnnotation<-c()

ClassPrediction<-c()
ClassGroundTruth<-c()
indd<-1






datasetIndexTest<-1
for (datasetIndexTest in 2:2) {
currentDataset<-dataset[[datasetIndexTest]]
#trainedModel<-"inhalerRF_A_CwtSCeMZ.Rdata"
trainedModel <- paste("E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Src/R/inhalerRF_A",feats,".RData", sep = "")
path <- "Test"
path <- currentDataset$path
fnms <- list.files(path = path, pattern = "([a-zA-Z0-9\\s_\\.\\-\\(\\):])+(.wav)$")
fnms<-unique(currentDataset$test$V1)
timeEval.measurements <- c()

rf = get(load(trainedModel))
doNormalize <- TRUE
wlen <- 4000
h <- wlen 

for (x in fnms[1:4]) {
    
    
    timeEval.feat = 0
    timeEval.time = 0
    timeEval.perwindow = 0
    timeEval.nwindows = 0
    timeEval.perwindowFeat = 0
    
    start.time <- Sys.time()
    #x<-paste(d1$path,'/',xi,sep="")
    xsplit <- strsplit(x, "\\.")
    for (xsplitIndex in 2:length(xsplit[[1]])) {
      xsplit[[1]][xsplitIndex] <-
        paste(".", xsplit[[1]][xsplitIndex], sep = "")
    }
    fnmNoExt <- NULL
    for (xsplitIndex in 1:length(xsplit[[1]]) - 1) {
      fnmNoExt <- paste(fnmNoExt, xsplit[[1]][xsplitIndex], sep = "")
    }
    fnmNoExt <- trimws(fnmNoExt)
    cFmn = paste(fnmNoExt, ".wav", sep = "")
    print(paste("Line # : ", which(x == fnms), " out of ", length(fnms), sep = ""))
    filename <- paste(path, "/", x, sep = "")
    annot <- currentDataset$test[currentDataset$test$V1 == x, ]
    print(cFmn)
    c <-
      readWave(
        filename,
        from = 1,
        to = Inf,
        header = FALSE,
        toWaveMC = TRUE
      )
    X <- c@.Data
    X <- X / (2 ^ (c@bit - 1))
    if (doNormalize) {
      X <- X / (sd(X))
    }
    Fs <- c@samp.rate
    Xin <- X[seq(1, length(X), Fs / 8000)]
    if ((96000 - length(Xin)) > 0) {
      Xin <- c(Xin, as.vector(matrix(0, 1, (
        96000 - length(Xin)
      ))))
    }
   

    
    
    S <- spect(Xin)
    C <- cepst(Xin)
    M <- mel(Xin)
    Z <- zcr(Xin)
    CWTMat <- cwtrfrm(Xin)
    CWTMat <- t(CWTMat)
    
    

    classificationResult <- c()
    for (i in seq(from = 1,
                  to = length(Xin) - wlen,
                  by = h)) {
      xd1 <- i
      xd2 <- i + wlen - 1
      a <- floor(xd1 / h)
      b <- floor(xd2 / h)
      if ((a != b) && (a > 0) && (b < ncol(S))) {
        SFeatures <- pextractor(S, a, b)
        CFeatures <- pextractor(C, a, b)
        MFeatures <- pextractor(M, a, b)
        ZFeature <- sextractor(Z, a, b)
        CWTFeature <- pextractor(CWTMat, a, b)
        Features = c(
          0
          ,as.vector(CWTFeature)
          ,as.vector(SFeatures)
          ,as.vector(CFeatures)
          ,as.vector(MFeatures)
          ,ZFeature
        )
        Features <- as.matrix(Features)
        FeaturesDT <- as.data.frame(t(Features))
        FeaturesDT[is.na(FeaturesDT)] <- 0
        FeaturesDT[(abs(FeaturesDT) < 1e-08)] <- 0
        #FeaturesDT<-cbind(V1=FeaturesDT$V1,FeaturesDT[,(imp>10)])
        pred = predict(rf, FeaturesDT)
        classificationResult <-
          cbind(classificationResult, as.numeric(pred))
        
      }
    }
    
    end.time <- Sys.time()
    timeEval.perFile <- as.numeric(end.time - start.time)
    print(timeEval.perFile)
    timeEval.measurements <-c(timeEval.perFile, timeEval.measurements)
    

    
    classificationResult[is.na(classificationResult)] <- 4
    classificationResult <- as.vector(classificationResult)
    Xinitial <- as.vector(Xin)
    buffer <- classificationResult
    colorful <- (matrix(4, 1, length(Xinitial)))
    colorful <- as.vector(colorful)
    for (i in 1:(length(buffer) - 1)) {
      k <- (i - 1) * h
      colorful[((wlen / 2) + (k + 1)):((wlen / 2) + (k + h - 1))] = buffer[i]
    }
    colorful <- as.vector(colorful)
    #colorful<-mmed(colorful,(1024+1))
    if (nrow(annot) > 0) {
      print("Starting validation")
      GroundTruth <- as.vector(matrix(0, 1, length(colorful)))
      for (j in 1:nrow(annot)) {
        r <- annot[j, ]
        if (r$V2 == "Drug") {
          GroundTruth[r$V3:r$V4] = 1
        }
        if (r$V2 == "Exhale") {
          GroundTruth[r$V3:r$V4] = 2
        }
        if (r$V2 == "Inhale") {
          GroundTruth[r$V3:r$V4] = 3
        }
        if (r$V2 == "Noise") {
          GroundTruth[r$V3:r$V4] = 4
        }
      }
      ClassPrediction <- c(ClassPrediction,colorful[GroundTruth > 0])
      ClassGroundTruth <- c(ClassGroundTruth,GroundTruth[GroundTruth > 0])
     
      }
    }
  }







ClassPrediction <-
  factor(ClassPrediction, levels = c(1, 2, 3, 4))
ClassGroundTruth <-
  factor(ClassGroundTruth, levels = c(1, 2, 3, 4))
confusionMatrix(ClassPrediction, ClassGroundTruth)


write.csv(
  t(timeEval.measurements),
  file = "E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Src/R/timeEvalRF_C_S_C_??_Z_4000.csv",
  row.names = FALSE,
  col.names = FALSE
)
sc <- scale_colour_manual(
  values = cols,
  breaks = c("1", "2", "3", "4"),
  labels = c("Drug", "Exhale", "Inhale", "Other")
)
ggplot(
  data.frame(time = 1:length(Xinitial), timeseries = Xinitial),
  aes(
    x = time,
    y = timeseries,
    color = (colorful)
  )
) +  geom_line() + scale_colour_gradientn(colours = rainbow(4))


