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
setwd("E:/Dropbox/_GroundWork/Inhaler")


#feats<-"_SCeMZ"
feats <- "_CwtSCeMZ"
#feats <- "_FG"


DFID <- "_f1_dei"
path <- "AudioAnnotator/sources/_f1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
annotation <-
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
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
  read.csv(paste(path, "/", "annotation", DFID, ".csv", sep = ""))
d18 <- list(
  DFID = DFID,
  path = path,
  annotation = annotation,
  DFFnm = DFFnm
)

#dataset <- list(d1,d2, d3, d4,d5, d6, d7, d8, d9, d10, d11, d12, d13, d14,d15,d16,d17)


#dataset <- list(d15,d16,d17)

dataset <- list(d1,d2)

for (dset in dataset) {
  DFID <- dset$DFID
  path <- dset$path
  annotation <- dset$annotation
  DFFnm <- dset$DFFnm
  
  doNormalize <- TRUE
  wlen <- 512
  h <- wlen / 4
  
  for (i in (1:nrow(annotation))) {
    
    
    fnm <- toString(annotation[i, 1])
    class <- toString(annotation[i, 2])
    xd1 <- annotation[i, 3]
    xd2 <- annotation[i, 4]
    xsplit <- strsplit(fnm, "\\.")
    fnmNoExt <- xsplit[[1]][1]
    
    
    
    filename <- paste(path, "/", fnm, sep = "")
    c <-
      readWave(
        filename,
        from = 1,
        to = Inf,
        header = FALSE,
        toWaveMC = TRUE
      )
    # X <- c@.Data
    # X<-X/(2^(c@bit-1))
    # if(doNormalize){
    # X<-X/(sd(X))
    # }
    Fs<-c@samp.rate
    # Xin <- X
    # S <- spect(Xin)
    # C <- cepst(Xin)
    # M <- mel(Xin)
    # Z <- zcr(Xin)
    # CWTMat<-cwtrfrm(Xin)
    # CWTMat<-t(CWTMat)
    
    
    S <-
      (read.csv(
        paste(path, "/", fnmNoExt, "_spect.csv", sep = ""),
        header = FALSE,
        sep = ","
      ))
    C <-
      (read.csv(
        paste(path, "/", fnmNoExt, "_cepst.csv", sep = ""),
        header = FALSE,
        sep = ","
      ))
    M <-
      (read.csv(
        paste(path, "/", fnmNoExt, "_mfcc.csv", sep = ""),
        header = FALSE,
        sep = ","
      ))
    Z <-
      (read.csv(
        paste(path, "/", fnmNoExt, "_zcr.csv", sep = ""),
        header = FALSE,
        sep = ","
      ))
    CWTMat <-
      (read.csv(
        paste(path, "/", fnmNoExt, "_cwt.csv", sep = ""),
        header = FALSE,
        sep = ","
      ))
    
    a <- floor((xd1*8000/Fs) / h) 
    b <- floor((xd2*8000/Fs) / h) 
    if ((a != b) && (a > 0) && (b<length(Z))) {
      print(paste("Line # ", i, " out of ", nrow(annotation), sep = ""))
      SFeatures <- pextractor(S, a, b)
      CFeatures <- pextractor(C, a, b)
      MFeatures <- pextractor(M, a, b)
      ZFeature <- sextractor(Z, a, b)
      CWTFeature <- pextractor(CWTMat, a, b)
      
      
      
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
      
      if (i == 1) {
        write.table((t(Features)),
                    file = DFFnm,
                    sep = ",",
                    col.names = FALSE,
                    row.names = FALSE,
                    append = FALSE
        )
      }
      else{
        write.table((t(Features)),
                    file = DFFnm,
                    sep = ",",
                    col.names = FALSE,
                    row.names = FALSE,
                    append = TRUE
        )
      }
    }
  }
}


# DF <- read.csv(file=DFFnm,header=FALSE)
#
# trainData<-as.data.frame(DF)
# trainData<-trainData[complete.cases(trainData),]
# trainData$V1 = factor(trainData$V1, levels = 1:4)
#
# rf = randomForest(V1 ~ ., trainData)
# save(rf,file = paste(path,"/","inhalerRF_", DFID, ".RData", sep = ""))
#
# ab=boosting(V1~.,trainData,coeflearn="Zhu")
# save(ab,file = paste(path,"/","inhalerAB_", DFID, ".RData", sep = ""))
