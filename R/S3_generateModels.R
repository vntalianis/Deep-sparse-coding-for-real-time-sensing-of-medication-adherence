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



modA <- rbind(DF1, DF2, DF3)
modB <- rbind(DF1, DF2, DF3,DF6,DF10,DF7,DF8)
modC <- rbind(DF1, DF2, DF3,DF6,DF10,DF7,DF8,DF11,DF12,DF13,DF14)
modD <- rbind(DF1,DF6,DF12,DF13,DF14)
modE <- rbind(DF6,DF12,DF13,DF14)


mod0 <- rbind(DF1, DF2)


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