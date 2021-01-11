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
suppressWarnings(suppressMessages(library("seewave")))
library(oce)
library(ggplot2)
pak <-
  c(
    "e1071",
    "adabag",
    "randomForest",
    "caret",
    "tuneR",
    "jsonlite",
    "ggplot2",
    "spate",
    "dtt",
    "Rwave",
    "foreach",
    "doParallel",
    "signal",
    "norm"
  )
setwd("E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Src/R")
source("functions.R")
options(warn = -1)
dtset <- c(
  "E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Data/sources/_f1",
  "E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Data/sources/_a1"
)
doNormalize <- FALSE





for (path in dtset) {
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
    
    ## Blister detection
    framelength = floor((100 / 1000) * c@samp.rate)
    framehop = floor((90 / 1000) * c@samp.rate)
    for (i in seq(from = 1,
                  to = length(Xin) - framelength,
                  by = framehop)) {
      XFrame <- Xin[i:(i + framelength)]
      w <- pwelch(XFrame, plot=TRUE,fs=c@samp.rate,nfft=1024)
      th1_meanPSD_2000_3000<-10*log10(mean(w$spec[w$freq>2000 & w$freq<3000]))
      th4_meanPSD_20_200<-10*log10(mean(w$spec[w$freq>20 & w$freq<200]))
      th2_XAmplitude <- max(abs(XFrame))
      
    }
    
    ## Breath detection
    framelength = floor((700 / 1000) * c@samp.rate)
    framehop = floor((680 / 1000) * c@samp.rate)
    for (i in seq(from = 1,
                  to = length(Xin) - framelength,
                  by = framehop)) {
      XFrame <- Xin[i:(i + framelength)]
      y<-melfreqs(XFrame,melcoeffs=24,wlen=512,Fs=8000,hop=128)
      
      #Compute theta5
      svd_y<-svd(y)
    
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  
  # listen(c)
  #
  #
  # df <- data.frame(dose = seq(1, length(X)), val = as.vector(X))
  # GRAPH <-
  #   ggplot(data = df, aes(x = dose, y = val, group = 1)) + geom_line() + geom_point()
  # GRAPH
  # fnms2 <-
  #   list.files(path = path, pattern = "annotation.")
  #
  # an <- paste(path,"/",fnms2, sep="")
  #
  # for(y in an){
  #
  #   annotation <- read.csv(y)
  #
  #   for (i in (1:nrow(annotation))) {
  #
  #     fnm = toString(annotation[i, 1])
  #     class = toString(annotation[i, 2])
  #     xd1 <- annotation[i, 3]
  #     xd2 <- annotation[i, 4]
  #
  #     xsplit <- strsplit(fnm, "\\.")
  #     fnmNoExt <- xsplit[[1]][1]
  #     filename <- paste(path, "/", fnm, sep = "")
  #
  #     c <-
  #       readWave(
  #         filename,
  #         from = 1,
  #         to = Inf,
  #         header = FALSE,
  #         toWaveMC = TRUE
  #       )
  #
  #     X <- c@.Data
  #
  #     # X <- X[xd1:xd2]
  #
  #     X <- X / (2 ^ (c@bit - 1))
  #
  #     if (doNormalize) {
  #       X <- X / (sd(X))
  #     }
  #
  #     Fs <- c@samp.rate
  #
  #     #Xin <- X
  #     Xin <- X[seq(1, length(X), Fs / 8000)]
  #     if ((96000 - length(Xin)) > 0) {
  #       Xin <- c(Xin, as.vector(matrix(0, 1, (
  #         96000 - length(Xin)
  #       ))))
  #     }
  #
  #     Xin <- Xin[xd1:xd2]
  #
  #     # plot(Xin, type = 'l', xlab = 'Samples', ylab = 'Amplitude')
  #
  #     # number of points to use for the fft
  #     nfft=1024
  #
  #     k <- seewave::ffilter(Xin,f=8000,from=2000,to=3000)
  #     # create spectrogram
  #     spec1 = specgram(x = k,
  #                      n = 1024,
  #                      Fs = Fs,
  #                      window = 800,
  #                      overlap = 80)
  #
  #     # discard phase information
  #     P_th1 = abs(spec1$S)
  #     # normalize
  #     P_th1 = P_th1/max(P_th1)
  #     # convert to dB
  #     P_th1 = 10*log10(P_th1)
  #
  #     # mean psd, threshold n.1
  #     mean_psd_th1[w] = mean(P_th1)
  #
  #     # amplitude, threshold n.2
  #     max_amp_th2[w] <- max(Xin)
  #
  #     # determine duration, threshold n.3
  #     duration = length(X)/c@samp.rate
  #
  #     # threshold n.4
  #     # filter
  #     X4 <- seewave::ffilter(Xin,f=8000,from=20,to=200)
  #     # create spectrogram
  #     spec_th4 = specgram(x = X4,
  #                         n = 1024,
  #                         Fs = Fs,
  #                         window = 800,
  #                         overlap = 80)
  #
  #     # discard phase information
  #     P_th4 = abs(spec_th4$S)
  #     # normalize
  #     P_th4 = P_th4/max(P_th4)
  #     # convert to dB
  #     P_th4 = 10*log10(P_th4)
  #
  #     # mean psd, threshold n.4
  #     mean_psd_th4[w] = mean(P_th4)
  #
  #     # threshold n.5
  #     spec_th5 = specgram(x = Xin,
  #                         n = 1024,
  #                         Fs = Fs,
  #                         window = 5600,
  #                         overlap = 260)
  #
  #     # find USV # Threshold No. 5
  #     o <- length(Xin)
  #     F <- 1400
  #     F0 <- 2 * F / o
  #     # filter specification
  #     filter <- cheby1(6,2,c(F0-F0*.1,F0+F0*.1),type="pass")
  #     # filtered signal
  #     sgnl <- signal::filter(filter, x=spec_th5$S)
  #     M <- mel(sgnl)
  #
  #     # M <- M[which(is.nan(M))]
  #     M[is.na(M)] = 0
  #     print(M)
  #     if(is.nan(M)){break}
  #     # M <- scale(M)
  #     svd.mod <- svd(M)
  #     svd_th5[w] <- svd.mod$v
  #
  #     zcr_th6[w] <- zcr(X)
  #
  #     # Threshold n.7
  #     # mean_psd_step_7[w] <- mean(P[which(spec1$f > 2520 & spec1$f < 4000)])
  #     d <- seewave::ffilter(Xin,f=8000,from=2520,to=4000)
  #     # discard phase information
  #
  #     spec_th7 = specgram(x = d,
  #                         n = 1024,
  #                         Fs = Fs,
  #                         window = 5600,
  #                         overlap = 260)
  #
  #     P7 = abs(spec_th7$S)
  #     # normalize
  #     P7 = P7/max(P7)
  #     # convert to dB
  #     P7 = 10*log10(P7)
  #
  #     mean_psd_step_7[w] <- mean(P7)
  #
  #     # find threshold No. 8
  #     # zcr_th8[w] <- seewave::zcr(Wave(left = c), 8000, channel = 1, wl = 800, ovlp = 10, plot = FALSE)
  #     zcr_th8[w] <- zcr_th6[w]
  #     # print(zcr_th8[w])
  #
  #
  #     prediction_th1[w] <- ifelse(mean_psd_th1[w] > -14.8, "Potential blister event", "Nonblister")
  #     prediction_th2[w] <- ifelse(max_amp_th2[w] > 8.1, "Potential blister event", "Nonblister")
  #     prediction_th3[w] <- ifelse(duration[w] < 1, "Potential blister event", "Nonblister")
  #     prediction_th4[w] <- ifelse(mean_psd_th4[w] > -16.2, "Potential blister event", "Nonblister")
  #
  #
  #     prediction_th5[w] <- ifelse(svd_th5[w] > 0.2, "Potential breath event", "Nonbreath")
  #     prediction_th6[w] <- ifelse(zcr_th6[w] > 0.02, "Potential breath event", "Nonbreath")
  #
  #     prediction_th7[w] <- ifelse(mean_psd_step_7[w] > -58.1, "Potential Inhalation", "Potential Exhalation")
  #     prediction_th8[w] <- ifelse(zcr_th8[w] > 0.02, "Potential Inhalation", "Potential Exhalation")
  #
  #     if((prediction_th1[w] == "Potential blister event") && (prediction_th2[w] == "Potential blister event" || prediction_th3[w] == "Potential blister event") && prediction_th4[w] == "Potential blister event"){
  #       prediction_class[w] <- "Drug"
  #     }
  #     else if(prediction_th5[w] == "Nonbreath" || prediction_th6[w] == "Nonbreath"){
  #       prediction_class[w] <- "Noise"
  #     }
  #     else if(prediction_th7[w] == "Potential Inhalation" || prediction_th8[w] == "Potential Inhalation"){
  #       prediction_class[w] <- "Inhale"
  #     }
  #     else{
  #       prediction_class[w] <- "Exhale"
  #     }
  #
  #     actual_class[w] <- class
  #
  #     w <- w + 1
  #
  #     if(i==40){break}
  #   }
  #   break
  # }
  #
  #
}

u <- union(prediction_class, actual_class)
confusionMatrix(factor(prediction_class, u), factor(actual_class, u))
print(confusionMatrix(factor(prediction_class, u), factor(actual_class, u)))