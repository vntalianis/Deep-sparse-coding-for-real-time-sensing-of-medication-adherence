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
suppressWarnings(suppressMessages(library("foreach")))
suppressWarnings(suppressMessages(library("doParallel")))
suppressWarnings(suppressMessages(library("seewave")))
suppressWarnings(suppressMessages(library("iplots")))
suppressWarnings(suppressMessages(library("Rwave")))
suppressWarnings(suppressMessages(library("ramify")))
source("functions.R")
options(warn = -1)
setwd("E:/Dropbox/_GroundWork/Development/Inhaler")
path <- "Input"
#path <- "Spacer"
fnmid<-5
fnms <- list.files(path)

filename <- paste(path, "/", fnms[fnmid], sep = "")

resolution<-24

annotation<-read.csv(paste(path, "/", "annotation.csv", sep = ""),header = FALSE)
colnames(annotation) <- c("filename","class","start","end")

c <-
  readWave(
    paste(path, "/", annotation$filename[1], sep = ""),
    from = 1,
    to = Inf,
    header = FALSE,
    toWaveMC = TRUE
  )

#listen(c)

X <- c@.Data
X<-X/(2^(c@bit-1))
Fs<-c@samp.rate
#randi(10,length(X))


colors= as.vector(matrix(4,length(X),1))
colors[annotation$start[1]:annotation$end[1]]=1
plot(X,  col=colors)





