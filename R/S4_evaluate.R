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
setwd("E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Src/R/")



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


DFID <- "_noises_1_n"
path <- "AudioAnnotator/sources/_noises_1"
DFFnm <- paste(path, "/", "DF", DFID, feats, ".csv", sep = "")
DF18 <- read.csv(file = DFFnm, header = FALSE)


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
  

  
  mod1<-
    rbind(DF1,DF6,DF10)

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
mod5b <-
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
        DF12,
        DF13,
        DF14,
        DF15,
        DF16,
        DF17)

mod5c <-
  rbind(DF1,
        DF2,
        DF3,
        #DF4,
        DF5,
        DF6,
        #DF7,
        #DF8,
        DF9,
        DF10,
        DF11,
        DF12,
        DF13,
        DF14,
        DF15,
        DF16,
        DF17)

mod5d <-
  rbind(DF1,
        DF2,
        DF3,
        #DF4,
        DF5,
        DF6,
        #DF7,
        #DF8,
        DF9,
        DF10,
        DF11,
        DF12,
        DF13,
        DF14,
        DF15,
        DF16,
        DF17,
        DF18)

mod6 <-
  rbind(DF1,
        DF2,
        DF3,
        DF14,
        DF6,
        DF10,
        DF11,
        DF13)


trainData <- mod5d
trainData <- trainData[complete.cases(trainData),]
trainData$V1 = factor(trainData$V1, levels = 1:4)
rf = randomForest(V1 ~ ., trainData[, ])
save(rf, file = paste("./", "inhalerRF_Av5d.RData", sep = ""))







