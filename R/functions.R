spect <- function(X) {
  wlen = 512
  hop <- wlen / 4
  nfeat <- 40
  len = (wlen / 2 + 1)
  y <- c()
  for (i in seq(from = 1,
                to = length(X) - wlen,
                by = hop)) {
    Xin <- X[i:(i + wlen)]
    w <- hanning.window(length(Xin))
    Xin <- Xin * w
    m <- fft(Xin)
    m <- abs(m[1:len])
    y <- cbind(y, as.vector(m))
  }
  y <- as.matrix(y)
  yf <- c()
  step = floor(nrow(y) / nfeat)
  for (i in seq(from = 1,
                to = (nrow(y) - step),
                by = step)) {
    y2 <- y[i:(i + step - 1), ]
    
    y3 <- colSums(y2)
    y3 <- y3 / step
    yf <- cbind(yf, as.vector(y3))
  }
  y <- as.matrix(yf)
  y <- t(y)
  return(y)
}


spectrogr<- function(X,wlen,hop,nfeat) {
  y <- c()
  for (i in seq(from = 1,
                to = length(X) - wlen,
                by = hop)) {
    Xin <- X[i:(i + wlen)]
    w <- hanning.window(length(Xin))
    Xin <- Xin * w
    m <- fft(Xin)
    m <- abs(m[1:(wlen / 2 + 1)])
    y <- cbind(y, as.vector(m))
  }
  y <- as.matrix(y)
  yf <- c()
  step = floor(nrow(y) / nfeat)
  for (i in seq(from = 1,
                to = (nrow(y) - step),
                by = step)) {
    y2 <- y[i:(i + step - 1), ]
    
    y3 <- colSums(y2)
    y3 <- y3 / step
    yf <- cbind(yf, as.vector(y3))
  }
  y <- as.matrix(yf)
  y <- t(y)
  return(y)
}




cepst <- function(X) {
  wlen = 512
  hop <- wlen / 4
  nfeat <- 40
  len = (wlen / 2 + 1)
  y <- c()
  
  for (i in seq(from = 1,
                to = length(X) - wlen,
                by = hop)) {
    Xin <- X[i:(i + wlen)]
    w <- hanning.window(length(Xin))
    Xin <- Xin * w
    m <- log(abs(fft(Xin)))
    m <- m[1:len]
    m <- (abs(m)) ^ 2
    m2 <- matrix(0, 1, 512)
    m2[1:len] = m[1:len]
    m <- m2
    m <- fft(m, inverse = TRUE) / length(m)
    m <- m[1:len]
    m <- (abs(m)) ^ 2
    y <- cbind(y, as.vector(m))
  }
  y <- as.matrix(y)
  y <- y[3:nrow(y), ]
  
  yf <- c()
  step = floor(nrow(y) / nfeat)
  for (i in seq(from = 1,
                to = (nrow(y) - step),
                by = step)) {
    y2 <- y[i:(i + step - 1), ]
    
    y3 <- colSums(y2)
    y3 <- y3 / step
    yf <- cbind(yf, as.vector(y3))
  }
  y <- as.matrix(yf)
  y <- t(y)
  return(y)
}

mel <- function(X) {
  y<-melfreqs(X,melcoeffs=40,wlen=512,Fs=8000,hop=128)
  

  return(y)
}



melfreqs <- function(X,melcoeffs,wlen,Fs,hop) {
  len = (wlen / 2 + 1)
  y <- c()
  
  for (i in seq(from = 1,
                to = length(X) - wlen,
                by = hop)) {
    Xin <- X[i:(i + wlen - 1)]
    w <- hanning.window(length(Xin))
    Xin <- Xin * w
    m <- fft(Xin)
    m <- abs(m)
    m <- (m ^ 2)
    maxFreq <- len * Fs / wlen
    minFreq <- Fs / wlen
    mmaxFreq <- 2592 * log10(1 + (maxFreq / 700))
    mminFreq <- 2592 * log10(1 + (minFreq / 700))
    step <- (abs(mmaxFreq - mminFreq) / (melcoeffs + 2))
    melfrequencies <- as.vector(matrix(0, 1, melcoeffs + 2))
    j <- 1
    for (k in seq(from = mminFreq,
                  to = mmaxFreq - step,
                  by = step)) {
      melfrequencies[j] <- k
      j = j + 1
    }
    f <- 700 * (10 ^ (melfrequencies / 2595) - 1)
    n <- floor(f * wlen / Fs) + 1
    #print(f)
    #print(n)
    filter = matrix(0, melcoeffs, wlen)
    filtered = matrix(0, melcoeffs, wlen)
    for (k in 1:melcoeffs) {
      for (j in 1:wlen) {
        if ((n[k] <= j) && (j <= n[k + 1])) {
          filter[k, j] <-
            (1 / (n[k + 1] - n[k])) * j - (n[k] / (n[k + 1] - n[k]))
        }
        if ((n[k + 1] <= j) && (j <= n[k + 2])) {
          filter[k, j] <-
            -(1 / (n[k + 2] - n[k + 1])) * j + (n[k + 2] / (n[k + 2] - n[k + 1]))
        }
      }
    }
    for (k in 1:melcoeffs) {
      filtered[k, ] <- filter[k, ] * m
    }
    mfccvals <- rowSums(filtered)
    mfccvals <- log10(mfccvals)
    mfccvals <- dct(mfccvals)
    mfccvals <- mfccvals[1:((length(mfccvals) / 2) + 1)]
    mfccvals <- t(mfccvals)
    y <- cbind(y, as.vector(mfccvals))
  }
  y <- as.matrix(y)
  y <- y[3:nrow(y), ]
  #y <- t(y)
  return(y)
}







cwtrfrm <- function(X) {
  wlen <- 512
  Fs <- 8000
  hop <- wlen / 4
  len = (wlen / 2 + 1)
  yf <- c()
  for (i in seq(from = 1,
                to = length(X) - wlen,
                by = hop)) {
    Xin <- X[i:(i + wlen - 1)]
    w <- hanning.window(length(Xin))
    Xin <- Xin * w
    cwtwindow <- cwt(
      as.vector(Xin),
      noctave = 5,
      nvoice = 8,
      plot = FALSE
    )
    cwtwindowabs <- (abs(cwtwindow))
    cwtwindowabs <- t(cwtwindowabs)
    cwtvals <- rowSums(cwtwindowabs)
    yf <- cbind(yf, as.vector(cwtvals))
  }
  y <- as.matrix(yf)
  y <- t(y)
  return(y)
}



zcr <- function(X) {
  wlen <- 512
  Fs <- 8000
  hop <- wlen / 4
  y <- c()
  for (i in seq(from = 1,
                to = length(X) - wlen,
                by = hop)) {
    Xin <- X[i:(i + wlen - 1)]
    zcr <- 0
    for (i in 1:(length(Xin) - 1)) {
      if (Xin[i] * Xin[i + 1]) {
        zcr <- zcr + 1
      }
    }
    zcr <- zcr / (length(Xin) - 1)
    y <- cbind(y, zcr)
  }
  #y<- t(y)
  return(y)
}


psd <- function(X,fs,from=NULL,to=NULL) {

  # w <- hanning.window(length(X))
  # X <- X * w
  # F_Xin<-Re(fft(X)[(1):((length(X)/2)+1)])
  # if (!is.null(from)){
  #   start<-floor((length(X)/2)*(from/fs))
  #   F_Xin[1:start]<-0
  # }
  # if (!is.null(to)){
  #   end<-floor((length(X)/2)*(to/fs))
  #   F_Xin[end:((length(X)/2)+1)]<-0
  # }
  # 
  # F_Xin<-F_Xin[start:end]
  # PSD_F_Xin<-10*log10(sum((F_Xin*F_Xin))/length(F_Xin))
  return(0)
}

meanpower<-function(x){
  wlen <- 512
  Fs <- 8000
  hop <- wlen
  y <- c()
  for (i in seq(from = 1,
                to = length(X) - wlen,
                by = hop)) {
    Xin <- X[i:(i + wlen - 1)]
    pwr <- 0
    for (i in 1:(length(Xin) - 1)) {
      pwr<-pwr+(Xin[i]*Xin[i])
    }
    pwr <- pwr / (length(Xin) - 1)
    y <- cbind(y, pwr)
  }
  return(y)
}






pextractor <- function(Xin, a, b) {
  Xi <- as.matrix(Xin)
  Xout <- Xi[, a:b]
  Xout <- ((rowSums(Xout)) / (b - a))
  return(Xout)
}

sextractor <- function(Xin, a, b) {
  Xout <- Xin[a:b]
  Xout <- sum(Xout) / length(Xout)
  return(Xout)
}



mav <- function(x, n = 5) {
  filter(x, rep(1 / n, n), sides = 2)
} #Average
mmed <- function(x, n) {
  runmed(x, n)
} #


shifter <- function(x, n = 1) {
  if (n == 0)
    x
  else
    c(tail(x,-n), head(x, n))
}
