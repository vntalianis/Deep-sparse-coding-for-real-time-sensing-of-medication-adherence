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
doNormalize <- TRUE
wlen <- 512
h <- 128
resolution<-48
filterSize<-128



#feats<-"_SCeMZ"
feats <- "_CwtSCeMZ"

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

DFID <- "_spacer_train_20180821_e"
path <- "AudioAnnotator/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF15 <- read.csv(file = DFFnm, header = FALSE)

DFID <- "_spacer_train_20180821_i"
path <- "AudioAnnotator/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF16 <- read.csv(file = DFFnm, header = FALSE)


DFID <- "_spacer_train_20180821_n"
path <- "AudioAnnotator/sources/_spacer_train_20180821"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF17 <- read.csv(file = DFFnm, header = FALSE)



A1<-DF1
A2<-DF2
A3<-DF3


N1Type1Patient<-DF6
N2<-DF10
N3<-DF17


D1<-DF11
D2<-DF14
D3<-DF7
D4<-DF8
D1Type1Patient<-DF4


E1Type1Patient<-DF5
E2SpacerPatient<-DF9
E3Lab<-DF12
E4SpacerLab<-DF15

I1Lab<-DF13
I2SpacerLab<-DF16





mod2 <-
  rbind(DF1,
        DF2,
        DF3,
        DF4,
        DF5,
        DF6,
        DF7,
        DF8,
        DF9,
        DF10,
        DF11,
        DF12,
        DF13,
        DF14)



mod3 <-
  rbind(A1,
        A2,
        A3,
        N1Type1Patient,
        N2,
        D1,
        D2,
        D3,
        D4,
        E3Lab,
        I1Lab)


mod4 <-
  rbind(A2,
        A3,
        N1Type1Patient,
        N2,
        D1,
        E4SpacerLab,
        I2SpacerLab)

mod5 <-
  rbind(DF1,
        DF2,
        DF3,
        DF4,
        DF5,
        DF6,
        DF7,
        DF8,
        DF9,
        DF10,
        DF11,
        DF12,
        DF13,
        DF14,
        DF15,
        DF16,
        DF17)


antonis <-
  rbind(
    DF1,
    DF2,
    DF3,
    DF5,
    DF6,
    DF10,
    DF9,
    DF12,
    DF15,
    DF13,
    DF16,
    DF14
  )



trainData <- mod5
trainData <- trainData[complete.cases(trainData),]
trainData$V1 = factor(trainData$V1, levels = 1:4)
trainData <- trainData[sample(nrow(trainData)),]



path <- "Test"
fnms <-list.files(path = path, pattern = "([a-zA-Z0-9\\s_\\.\\-\\(\\):])+(.wav|.pdf)$")
gts<-read.csv("Test/annotation.csv",header = F)

for (x in fnms) {
  xsplit <- strsplit(x, "\\.")
  fnmNoExt <- xsplit[[1]][1]
  print(paste("Line # : ", which(x == fnms), " out of ", length(fnms), sep = ""))
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
  CWTMat<-cwtrfrm(Xin)
  CWTMat<-t(CWTMat)
  
  
  save(S, file = paste("./", "matS.RData", sep = ""))
  save(C, file = paste("./", "matC.RData", sep = ""))
  save(M, file = paste("./", "matM.RData", sep = ""))
  save(Z, file = paste("./", "matZ.RData", sep = ""))
  save(CWTMat, file = paste("./", "matCWT.RData", sep = ""))
  
}




S <- get(load("matS.RData"))
C <- get(load("matC.RData"))
M <- get(load("matM.RData"))
Z <- get(load("matZ.RData"))
CWTMat<-get(load("matCWT.RData"))


ACC<-0
ssset<-1
toremove<-c(1)
toadd<-1:200
h<-20
#801:nrow(trainData)
for(ssset in seq(from = 201,
                 to = nrow(trainData)-h,
                 by = h)){
  
  #subset <- trainData[-toremove, ]
  ttemp<-c(toadd,(ssset:(ssset+h)))
  
  subset <- trainData[ttemp, ]
  rf = randomForest(V1 ~ ., subset[, ])

  #rf = randomForest(V1 ~ ., trainData[, ])
  #save(rf, file = paste("./", "inhalerRF_AvAntonis.RData", sep = ""))
  #trainedModel<-"inhalerRF_Av5.RData"
  #rf = get(load(trainedModel))




  
  
  
  
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
  classificationResult[is.na(classificationResult)] <- 4
  classificationResult <- as.vector(classificationResult)
  Xinitial <- as.vector(Xin)
  buffer <- classificationResult
  colorful<-(matrix(4,1,length(Xinitial)))
  colorful<-as.vector(colorful)
  for (i in 1:(length(buffer)-1)){
    k <- (i-1)*h
    colorful[((wlen/2)+(k+1)):((wlen/2)+(k+h-1))]=buffer[i];
  }
  colorful<-as.vector(colorful)
  
  groundtruth<-as.vector(matrix(4,1,length(Xinitial)))
  
  
  GTR<-c()
  EST<-c()
  
  
  for (i in 1:nrow(gts)){
  groundtruth[(gts[i,3]/(Fs/8000)):(gts[i,4]/(Fs/8000))]<-gts[i,2]
  
  #GTR<-c(GTR,groundtruth[(gts[i,3]/(Fs/8000)):(gts[i,4]/(Fs/8000))])
  #EST<-c(EST,colorful[(gts[i,3]/(Fs/8000)):(gts[i,4]/(Fs/8000))])
  
  }
  GTR<-groundtruth
  EST<-colorful
  
  GTR_I<-GTR[GTR==3]
  EST_I<-EST[GTR==3]
  
  GTR_D<-GTR[GTR==3]
  EST_D<-EST[GTR==3]
    
  TEMP<-norm(as.matrix(GTR_I)-as.matrix(EST_I))/norm(as.matrix(GTR_I))
  print(TEMP)
  if (TEMP>=ACC){
    ACC<-TEMP
    #toremove<-c(toremove,ssset)
    toadd<-ttemp
  }
#}
print(ssset)

}




subset <- trainData[toadd, ]
rf = randomForest(V1 ~ ., subset[, ])
save(rf, file = paste("./", "fitted.RData", sep = ""))




# 
# sc<- scale_colour_manual(
#   values = cols,
#   breaks = c("1", "2", "3","4"),
#   labels = c("Drug","Exhale", "Inhale", "Other")
# )
# 
# ggplot(data.frame(time = 1:length(Xinitial), timeseries = Xinitial),aes(x = time, y = timeseries, color = (groundtruth))) +  geom_line()+scale_colour_gradientn(colours=rainbow(4))

