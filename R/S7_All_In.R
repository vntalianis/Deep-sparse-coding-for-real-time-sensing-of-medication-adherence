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

# path <- "AudioAnnotator/sources/_f1"
# path <- "AudioAnnotator/sources/_g1"
# path <- "AudioAnnotator/sources/_a1"
# path <- "AudioAnnotator/sources/_type1"
# path <- "AudioAnnotator/sources/_uploads_2"
# path <- "AudioAnnotator/sources/_uploads_3"
# path <- "AudioAnnotator/sources/_uploads_spacer"
# path <- "AudioAnnotator/sources/_sn201807"
# path <- "AudioAnnotator/sources/_sn20180730"

dtset <- c(
  "AudioAnnotator/sources/_a1",
  "AudioAnnotator/sources/_f1",
  "AudioAnnotator/sources/_g1",
  "AudioAnnotator/sources/_type1",
  "AudioAnnotator/sources/_uploads_2",
  "AudioAnnotator/sources/_uploads_3",
  "AudioAnnotator/sources/_uploads_spacer",
  "AudioAnnotator/sources/_sn201807",
  "AudioAnnotator/sources/_sn20180730",
  "AudioAnnotator/sources/_spacer_train_20180821",
  "AudioAnnotator/sources/_noises_1"
)


if(FALSE){

for (path in dtset) {
  doNormalize <- TRUE
  wlen <- 512
  h <- wlen / 4
  fnms <-
    list.files(path = path, pattern = "([a-zA-Z0-9\\s_\\.\\-\\(\\):])+(.wav|.xxxxx)$")
  ndigits <- 6
  
  for (x in fnms) {
    print(paste("Line # : ", which(x == fnms), " out of ", length(fnms), sep = ""))
    xsplit <- strsplit(x, "\\.")
    fnmNoExt <- xsplit[[1]][1]
    filename <- paste(path, "/", x, sep = "")
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
    #Xin <- X
    Xin <- X[seq(1, length(X), Fs / 8000)]
    if ((96000 - length(Xin)) > 0) {
      Xin <- c(Xin, as.vector(matrix(0, 1, (
        96000 - length(Xin)
      ))))
    }
    
    S <- spect(Xin)
    S <- round(S, digits = ndigits)
    DFFnm <- paste(path, "/", fnmNoExt, "_spect", ".csv", sep = "")
    write.table(
      S,
      file = DFFnm,
      sep = ",",
      col.names = FALSE,
      row.names = FALSE,
      append = FALSE
    )
    
    
    C <- cepst(Xin)
    C <- round(C, digits = ndigits)
    DFFnm <- paste(path, "/", fnmNoExt, "_cepst", ".csv", sep = "")
    write.table(
      C,
      file = DFFnm,
      sep = ",",
      col.names = FALSE,
      row.names = FALSE,
      append = FALSE
    )
    
    
    M <- mel(Xin)
    M <- round(M, digits = ndigits)
    DFFnm <- paste(path, "/", fnmNoExt, "_mfcc", ".csv", sep = "")
    write.table(
      M,
      file = DFFnm,
      sep = ",",
      col.names = FALSE,
      row.names = FALSE,
      append = FALSE
    )
    
    
    Z <- zcr(Xin)
    Z <- round(Z, digits = ndigits)
    DFFnm <- paste(path, "/", fnmNoExt, "_zcr", ".csv", sep = "")
    write.table(
      Z,
      file = DFFnm,
      sep = ",",
      col.names = FALSE,
      row.names = FALSE,
      append = FALSE
    )
    
    
    
    CWTMat <- cwtrfrm(Xin)
    CWTMat <- t(CWTMat)
    CWTMat <- round(CWTMat, digits = ndigits)
    DFFnm <- paste(path, "/", fnmNoExt, "_cwt", ".csv", sep = "")
    write.table(
      CWTMat,
      file = DFFnm,
      sep = ",",
      col.names = FALSE,
      row.names = FALSE,
      append = FALSE
    )
  }
}

}


#feats<-"_SCeMZ"
feats <- "_CwtSCeMZ"
#feats <- "_FG"
feats <- "_ALLIN"

DFID <- "_f1_dei"
path <- "AudioAnnotator/sources/_f1"
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
path <- "AudioAnnotator/sources/_g1"
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
path <- "AudioAnnotator/sources/_a1"
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
path <- "AudioAnnotator/sources/_type1"
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
path <- "AudioAnnotator/sources/_type1"
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
path <- "AudioAnnotator/sources/_type1"
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
path <- "AudioAnnotator/sources/_uploads_2"
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
path <- "AudioAnnotator/sources/_uploads_3"
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
path <- "AudioAnnotator/sources/_uploads_spacer"
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
path <- "AudioAnnotator/sources/_uploads_spacer"
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
path <- "AudioAnnotator/sources/_sn201807"
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
path <- "AudioAnnotator/sources/_sn201807"
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
path <- "AudioAnnotator/sources/_sn201807"
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
path <- "AudioAnnotator/sources/_sn20180730"
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
path <- "AudioAnnotator/sources/_spacer_train_20180821"
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
path <- "AudioAnnotator/sources/_spacer_train_20180821"
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
path <- "AudioAnnotator/sources/_spacer_train_20180821"
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
path <- "AudioAnnotator/sources/_noises_1"
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

#dataset <- list(d1,d2, d3, d4,d5, d6, d7, d8, d9, d10, d11, d12, d13, d14,d15,d16,d17)
#dataset <- list(d15,d16,d17)

dataset <- list(d1,d2,d3)

testAnnotation<-c()
trainAnnotation<-c()

ClassPrediction<-c()
ClassGroundTruth<-c()
indd<-1



for (indd in 1:numberOfFolds){
dsetIndex<-1
for (dsetIndex in 1:length(dataset)) {
  dset<-dataset[[dsetIndex]]
  DFID <- dset$DFID
  path <- dset$path
  annotation <- dset$annotation
  uAnnot <- unique(annotation$V1)
  folds <-
    cut(seq(1, length(uAnnot)), breaks = numberOfFolds, labels = FALSE)
  testData <- c()
  trainData <- c()
  
  #for (i in 1:numberOfFolds) {
    testIndexes <- which(folds == indd, arr.ind = TRUE)
    testData <- uAnnot[testIndexes]
    trainData <- uAnnot[-testIndexes]
    mLog <- dset$annotation$V1 == ""
    for (e in annotation$V1) {
      for (d in testData) {
        if (e == d) {
          g = which(e == annotation$V1)
          mLog[g] = TRUE
        }
      }
    }
    testAnnotation <- dset$annotation[mLog, ]
    trainAnnotation <- dset$annotation[!mLog, ]
    dset$test<-testAnnotation
    dset$train<-trainAnnotation
    dataset[[dsetIndex]]<-dset
    
  #}
  
  
  
  DFFnm <- dset$DFFnm
  
  doNormalize <- TRUE
  wlen <- 512
  h <- wlen / 4
  
  
  for (i in (1:nrow(dset$train))) {
  
  
  
  
  ####################################################################
  
  
  
  
  
  
  # path <- dataset[[1]]$path
  # filenames<-unique(dataset[[1]]$annotation$V1)
  # fnm<-filenames[1]
  # for (fnm in filenames){
  #   print(fnm)
  #   filename <- paste(path, "/", fnm, sep = "")
  #   c <-
  #     readWave(
  #       filename,
  #       from = 1,
  #       to = Inf,
  #       header = FALSE,
  #       toWaveMC = TRUE
  #     )
  #   matchedIndices<-which(filenames==filenames[1])
  #   annotationCurrent <- rep(4, length(c@.Data))
  #   matchedIndex<-1
  #   for (matchedIndex in matchedIndices){
  #     dref<-dataset[[1]]$annotation
  #     annotationCurrent[dref$V3[matchedIndex]:dref$V4[matchedIndex]]<-dref$V2[matchedIndex]
  #   }
  #   
  #   for (i in seq(1, length(annotationCurrent)-4000, by = 1)) {
  #     class <- median(annotationCurrent[i:(i+4000)])
  #     xd1 <- i
  #     xd2 <- i+4000
  #     
  #   }
  # } 
  


  
  
  
  
  

  
  
  
 
    
    
    fnm <- toString(dset$train[i, 1])
    class <- toString(dset$train[i, 2])
    xd1 <- dset$train[i, 3]
    xd2 <- dset$train[i, 4]
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
      print(paste("Line # ", i, " out of ", nrow(dset$train), sep = ""))
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
        classIndex
        #,as.vector(CWTFeature)
        ,as.vector(SFeatures)
        #,as.vector(CFeatures)
        #,as.vector(MFeatures)
        #,ZFeature
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


DFID <- "_f1_dei"
path <- "AudioAnnotator/sources/_f1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF1 <- read.csv(file = DFFnm, header = FALSE)

DFID <- "_g1_dei"
path <- "AudioAnnotator/sources/_g1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF2 <- read.csv(file = DFFnm, header = FALSE)

DFID <- "_a1_dei"
path <- "AudioAnnotator/sources/_a1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF3 <- read.csv(file = DFFnm, header = FALSE)

DFID <- "_type1_d"
path <- "AudioAnnotator/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF4 <- read.csv(file = DFFnm, header = FALSE)

DFID <- "_type1_e"
path <- "AudioAnnotator/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF5 <- read.csv(file = DFFnm, header = FALSE)

DFID <- "_type1_n"
path <- "AudioAnnotator/sources/_type1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF6 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_uploads_2_d"
path <- "AudioAnnotator/sources/_uploads_2"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF7 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_uploads_3_d"
path <- "AudioAnnotator/sources/_uploads_3"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF8 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_uploads_spacer_e"
path <- "AudioAnnotator/sources/_uploads_spacer"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF9 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_uploads_spacer_n"
path <- "AudioAnnotator/sources/_uploads_spacer"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF10 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_sn201807_d"
path <- "AudioAnnotator/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF11 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_sn201807_e"
path <- "AudioAnnotator/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF12 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_sn201807_i"
path <- "AudioAnnotator/sources/_sn201807"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF13 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_sn20180730_d"
path <- "AudioAnnotator/sources/_sn20180730"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF14 <- read.csv(file = DFFnm, header = FALSE)


#mods<-list(DF1, DF2, DF3)
#mods<-list(DF1)

# modA <- rbind(DF1, DF2, DF3)
# modB <- rbind(DF1, DF2, DF3,DF6,DF10,DF7,DF8)
# modC <- rbind(DF1, DF2, DF3,DF6,DF10,DF7,DF8,DF11,DF12,DF13,DF14)
# modD <- rbind(DF1,DF6,DF12,DF13,DF14)
# modE <- rbind(DF6,DF12,DF13,DF14)




modA <- rbind(DF1, DF3)
#modA <- rbind(DF1)
dtset <-
  list(
    list(data = modA, tag = paste("A",feats, sep = ""))
    #list(data = modB, tag = paste("B",feats, sep = "")),
    #list(data = modC, tag = paste("C",feats, sep = "")),
    #list(data = modD, tag = paste("D",feats, sep = ""))
    #list(data = mod0, tag = paste("0",feats, sep = ""))
  )
for (d in dtset){
  DF <- d$data
  DFM <- d$tag
  trainData <- as.data.frame(DF)
  trainData <- trainData[complete.cases(trainData),]
  trainData$V1 = factor(trainData$V1, levels = 1:4)
  rf = randomForest(V1 ~ ., trainData[,])
  imp <- importance(rf)
  ntr <- cbind(V1 = trainData$V1, trainData[, (imp > 10)])
  rf_important = randomForest(V1 ~ ., ntr)
  plot(imp)
  imp <- as.data.frame((imp))
  #write.csv(imp,file="./importance.csv",row.names=FALSE)
  save(imp, file = "./importance.RData")
  save(rf, file = paste("./", "inhalerRF_", DFM, ".RData", sep = ""))
  #ab=boosting(V1~.,trainData,coeflearn="Zhu")
  #save(ab,file = paste(path,"/","inhalerAB_", DFM, ".RData", sep = ""))
  
}



datasetIndexTest<-1
for (datasetIndexTest in 2:2) {
currentDataset<-dataset[[datasetIndexTest]]
trainedModel <- "inhalerRF_A_CwtSCeMZ.RData"
trainedModel <- paste("inhalerRF_A",feats,".RData", sep = "")
path <- "Test"
path <- currentDataset$path
fnms <- list.files(path = path, pattern = "([a-zA-Z0-9\\s_\\.\\-\\(\\):])+(.wav)$")
fnms<-unique(currentDataset$test$V1)
timeEval.measurements <- c()
  for (x in fnms) {
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
          0
          #,as.vector(CWTFeature)
          ,as.vector(SFeatures)
          #,as.vector(CFeatures)
          #,as.vector(MFeatures)
          #,ZFeature
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
      ClassPrediction <- c(ClassPrediction,colorful[GroundTruth > 0])
      ClassGroundTruth <- c(ClassGroundTruth,GroundTruth[GroundTruth > 0])
     
    }
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


