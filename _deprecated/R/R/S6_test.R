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
suppressWarnings(suppressMessages(library("tictoc")))

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
setwd("E:/Dropbox/_GroundWork/Inhaler")
doNormalize <- TRUE
wlen <- 512
h <- wlen / 4
#resolution <- 48
#filterSize <- 128




#feats<-"_SCeMZ"
feats <- "_CwtSCeMZ"
#feats <- "_FG"


DFID <- "_f1_dei"
path <- "AudioAnnotator/sources/_f1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d1 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)



DFID <- "_g1_dei"
path <- "AudioAnnotator/sources/_g1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d2 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)




DFID <- "_a1_dei"
path <- "AudioAnnotator/sources/_a1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d3 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)


DFID <- "_type1_d"
path <- "AudioAnnotator/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d4 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)



DFID <- "_type1_e"
path <- "AudioAnnotator/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d5 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)




DFID <- "_type1_n"
path <- "AudioAnnotator/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d6 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)



DFID <- "_uploads_2_d"
path <- "AudioAnnotator/sources/_uploads_2"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d7 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)


DFID <- "_uploads_3_d"
path <- "AudioAnnotator/sources/_uploads_3"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d8 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)




DFID <- "_uploads_spacer_e"
path <- "AudioAnnotator/sources/_uploads_spacer"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d9 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)




DFID <- "_uploads_spacer_n"
path <- "AudioAnnotator/sources/_uploads_spacer"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d10 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)







DFID <- "_sn201807_d"
path <- "AudioAnnotator/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d11 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)

DFID <- "_sn201807_e"
path <- "AudioAnnotator/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d12 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)





DFID <- "_sn201807_i"
path <- "AudioAnnotator/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d13 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)






DFID <- "_sn20180730_d"
path <- "AudioAnnotator/sources/_sn20180730"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d14 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)

DFID <- "_spacer_train_20180821_e"
path <- "AudioAnnotator/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d15 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)

DFID <- "_spacer_train_20180821_i"
path <- "AudioAnnotator/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d16 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)

DFID <- "_spacer_train_20180821_n"
path <- "AudioAnnotator/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d17 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)


DFID <- "_noises_1_n"
path <- "AudioAnnotator/sources/_noises_1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""), header =
             FALSE)
d18 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)



#trainedModel <- "inhalerRF_Av5d.RData"
#trainedModel <- "inhalerRF_Av6.RData"
#trainedModel <- "inhalerRF_Av1c.RData"
trainedModel <- "inhalerRF_A_CwtSCeMZ.RData"









path <- "Test"
path <- d1$path
fnms <-
  list.files(path = path, pattern = "([a-zA-Z0-9\\s_\\.\\-\\(\\):])+(.wav)$")
timeEval.measurements <- c()
for (mRepeat in 1:1) {
  for (x in fnms) {
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
    annot <- d1$annotation[d1$annotation$V1 == x, ]
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
    rf = get(load(trainedModel))
    timeEval.feat = 0
    timeEval.time = 0
    timeEval.perwindow = 0
    timeEval.nwindows = 0
    timeEval.perwindowFeat = 0
    
    start.time <- Sys.time()
    S <- spect(Xin)
    end.time <- Sys.time()
    time.taken <- as.numeric(end.time - start.time)
    #print(time.taken)
    timeEval.feat = timeEval.feat + time.taken
    
    
    start.time <- Sys.time()
    C <- cepst(Xin)
    end.time <- Sys.time()
    time.taken <- as.numeric(end.time - start.time)
    #print(time.taken)
    #timeEval.feat = timeEval.feat + time.taken
    start.time <- Sys.time()
    M <- mel(Xin)
    end.time <- Sys.time()
    time.taken <- as.numeric(end.time - start.time)
    #print(time.taken)
    #timeEval.feat = timeEval.feat + time.taken
    start.time <- Sys.time()
    Z <- zcr(Xin)
    end.time <- Sys.time()
    time.taken <- as.numeric(end.time - start.time)
    #print(time.taken)
    #timeEval.feat = timeEval.feat + time.taken
    start.time <- Sys.time()
    CWTMat <- cwtrfrm(Xin)
    CWTMat <- t(CWTMat)
    end.time <- Sys.time()
    time.taken <- as.numeric(end.time - start.time)
    #print(time.taken)
    #timeEval.feat = timeEval.feat + time.taken
    #timeEval.nwindows <- as.integer((length(Xin) - wlen) / h) - 3
    #timeEval.perwindowFeat <- timeEval.feat / timeEval.nwindows
    
    classificationResult <- c()
    start.time <- Sys.time()
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
          0,
          as.vector(CWTFeature),
          as.vector(SFeatures),
          as.vector(CFeatures),
          as.vector(MFeatures),
          ZFeature
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
    time.windows <- as.numeric(end.time - start.time)
    timeEval.perFile <- (timeEval.feat + time.windows)
    timeEval.measurements <-
      c(timeEval.perFile, timeEval.measurements)
    #timeEval.perwindow<-timeEval.perwindow/timeEval.nwindows
    #print(timeEval.perwindow)
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
      ClassPrediction <- colorful[GroundTruth > 0]
      ClassGroundTruth <- GroundTruth[GroundTruth > 0]
      ClassPrediction <-
        factor(ClassPrediction, levels = c(1, 2, 3, 4))
      ClassGroundTruth <-
        factor(ClassGroundTruth, levels = c(1, 2, 3, 4))
      confusionMatrix(ClassPrediction, ClassGroundTruth)
    }
  }
}
write.csv(
  t(timeEval.measurements),
  file = "timeEvalRFSpect.csv",
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
