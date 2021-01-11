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
source("src/R/functions.R")
options(warn = -1)
setwd("E:/Dropbox/_GroundWork/Inhaler/Src/R")

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
  "Data/sources/_f1",
  "Data/sources/_a1",
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

for (path in dtset) {
  doNormalize <- FALSE
  wlen <- 512
  h <- wlen / 4
  ndigits <- 6
  fnms <-
    list.files(path = path, pattern = "([a-zA-Z0-9\\s_\\.\\-\\(\\):])+(.wav|.xxxxx)$")
  
  
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
    X <- X / (2 ^ (c@bit))
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
    
    library(seewave)
    
    Xin_Filtered<-ffilter(Xin,f=8000,from=1300,to=1700)
    spectro(Xin_Filtered,f=8000,wl=512)
    spectro(Xin,f=8000,wl=512)
    P<-meanpower(Xin_Filtered)
    P<-10*log10(P)
    
    df <- data.frame(dose=seq(1, length(P)),val=as.vector(Xin_Filtered))
    listen(c)
    library(ggplot2)
    # Basic line plot with points
    GRAPH<-ggplot(data=df, aes(x=dose, y=val, group=1)) +geom_line()+geom_point()
    GRAPH
}}
    
    
#     
#     
#     S <- spect(Xin)
#     S <- round(S, digits = ndigits)
#     DFFnm <- paste(path, "/", fnmNoExt, "_spect", ".csv", sep = "")
#     write.table(
#       S,
#       file = DFFnm,
#       sep = ",",
#       col.names = FALSE,
#       row.names = FALSE,
#       append = FALSE
#     )
# 
# 
#     C <- cepst(Xin)
#     C <- round(C, digits = ndigits)
#     DFFnm <- paste(path, "/", fnmNoExt, "_cepst", ".csv", sep = "")
#     write.table(
#       C,
#       file = DFFnm,
#       sep = ",",
#       col.names = FALSE,
#       row.names = FALSE,
#       append = FALSE
#     )
# 
# 
#     M <- mel(Xin)
#     M <- round(M, digits = ndigits)
#     DFFnm <- paste(path, "/", fnmNoExt, "_mfcc", ".csv", sep = "")
#     write.table(
#       M,
#       file = DFFnm,
#       sep = ",",
#       col.names = FALSE,
#       row.names = FALSE,
#       append = FALSE
#     )
# 
# 
#     Z <- zcr(Xin)
#     Z <- round(Z, digits = ndigits)
#     DFFnm <- paste(path, "/", fnmNoExt, "_zcr", ".csv", sep = "")
#     write.table(
#       Z,
#       file = DFFnm,
#       sep = ",",
#       col.names = FALSE,
#       row.names = FALSE,
#       append = FALSE
#     )
# 
#     
#     
#     CWTMat <- cwtrfrm(Xin)
#     CWTMat <- t(CWTMat)
#     CWTMat <- round(CWTMat, digits = ndigits)
#     DFFnm <- paste(path, "/", fnmNoExt, "_cwt", ".csv", sep = "")
#     write.table(
#       CWTMat,
#       file = DFFnm,
#       sep = ",",
#       col.names = FALSE,
#       row.names = FALSE,
#       append = FALSE
#     )
#     
#     
#     
# 
#   }
# }















#X<-X/max(X)
#X<-(length(X)/Fs)*X/sum(X)
#X<-X/sqrt((sum(X^2)/length(X)))
#X<-X/max(X)
#X<-0.5*X
# a <- floor(xd1 / h)
# b <- floor((xd2-wlen) / h)
# if ((a != b)&&(a>0)) {
#   SFeatures <- pextractor(S, a, b)
#   CFeatures <- pextractor(C, a, b)
#   MFeatures <- pextractor(M, a, b)
#   ZFeature <- sextractor(Z, a, b)
#   CWTFeature<- pextractor(CWTMat, a, b)
#   classIndex = 1
#   if (class == "Drug") {
#     classIndex = 1
#   }
#   if (class == "Exhale") {
#     classIndex = 2
#   }
#   if (class == "Inhale") {
#     classIndex = 3
#   }
#   if (class == "Noise") {
#     classIndex = 4
#   }
#   Features = c(
#     classIndex,
#     as.vector(CWTFeature),
#     as.vector(SFeatures),
#     as.vector(CFeatures),
#     as.vector(MFeatures),
#     ZFeature
#   )
#   Features <- as.matrix(Features)
#
#   if (i==1){
#     write.table((t(Features)), file = DFFnm, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE)
#   }
#   else{
#     write.table((t(Features)), file = DFFnm, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE)
#   }
# }
# DF <- read.csv(file=DFFnm,header=FALSE)
#
#
# trainData<-as.data.frame(DF)
# trainData<-trainData[complete.cases(trainData),]
# trainData$V1 = factor(trainData$V1, levels = 1:4)
#
#
#
# rf = randomForest(V1 ~ ., trainData)
# save(rf,file = paste(path,"/","inhalerRF_", DFID, ".RData", sep = ""))
#
# ab=boosting(V1~.,trainData,coeflearn="Zhu")
# save(ab,file = paste(path,"/","inhalerAB_", DFID, ".RData", sep = ""))
# library(reshape2)
# library(ggplot2)
# longData<-melt(S)
# longData<-longData[longData$value!=0,]
#
# ggplot(longData, aes(x = Var2, y = Var1)) +
#   geom_raster(aes(fill=value)) +
#   scale_fill_gradient(low="grey90", high="red") +
#   labs(x="letters", y="LETTERS", title="Matrix") +
#   theme_bw() + theme(axis.text.x=element_text(size=9, angle=0, vjust=0.3),
#                      axis.text.y=element_text(size=9),
#                      plot.title=element_text(size=11))
