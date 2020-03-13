library(missForest)
library(mixtools)
library(oce)
library(ggplot2) 
setwd("E:/Dropbox/_GroundWork/Inh_001_2018_mHealth_IEEE_Access/Inhaler/Src/R")
D1<-read.csv(file ="timeEvalRF_C_S_C_??_Z_4000.csv",header = TRUE)
D2<-read.csv(file ="timeEvalCNN.csv",header = FALSE)
D3<-read.csv(file ="timeEvalRFSpect4000.csv",header = TRUE)
D1<-D1[,D1!=0]
D3<-D3[,D3!=0]

D2<-D2[,D2!=0]
D2<-D2*12/0.5


D11<-rbind(as.matrix(D1),as.vector(matrix(1, 1, length(D1))))
D22<-rbind(as.matrix(D2),as.vector(matrix(2, 1, length(D2))))
D33<-rbind(as.matrix(D3),as.vector(matrix(3, 1, length(D3))))
D<-cbind(D11,D22,D33)




MM=as.data.frame(t(D))
colnames(MM)<-cbind('V1','V2')
MM$V2<-as.character(MM$V2)
GRAPH<-ggplot(MM, aes(x = V2, y = V1))  +
  geom_boxplot(alpha=0.7) +
  scale_y_continuous(name = "Execution times (in seconds)") +
  scale_x_discrete(name = "",limits=c("1","3","2"),labels=c("1"="Random Forest on features (STFT,Cepst,MFCC,ZCR,CWT)",
                                                            "3"="Random Forest on STFT features",
                                                            "2"="CNN (Model 5 without sparsity) on time domain")) +
  
  #scale_x_discrete(name = "",limits=c("3","2"),labels=c("3"="Random Forest on STFT features","2"="CNN (Model 5 without sparsity) on time domain")) +
  
  #ggtitle("Boxplot of ean ozone by month") +
  theme_bw() +
  theme(plot.title = element_text(size = 26, family = "Tahoma", face = "bold"),
        text = element_text(size = 26, family = "Source Sans Pro Semibold",lineheight = 40),
        # axis.title = element_text(face=""),
        axis.text.x=element_text(size = 20),
        panel.grid.major = element_line(size = 0.6, linetype = 'solid',
                                        colour = "gray"), 
        panel.grid.minor = element_line(size = 0.4, linetype = 'solid',
                                        colour = "gray"), 
        legend.position = c(0.61,0.135),
        legend.text.align = NULL,
        legend.title = element_blank(),
        legend.key.size = unit(1.0, "cm"), 
        legend.background = element_rect(fill = "white",linetype = "solid",colour = "gray"),
        legend.key = element_rect(fill = "white", color = NA),
        legend.text = element_text(color = "black", size = 20,lineheight = 20),
        legend.direction = "vertical") +
  scale_fill_brewer(palette = "Accent") +
  labs(fill = "")


GRAPH



