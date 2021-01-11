
rm(list = ls())
B <- matrix(c(126, 3, 10, 57, 0, 34,1,128,5,10,182,31,49,38,11,523),nrow=4, ncol=4)
B<-as.data.frame(B)
rownames(B) <- c("BLI_True","EXH_True","INH_True","INT_True")
colnames(B) <- c("BLI_Est","EXH_Est","INH_Est","INT_Est")


Acc<-(B[1,1]+B[2,2]+B[3,3]+B[4,4])/sum(B)

sensitivityVals<-matrix(NA,1,4)
sensitivityVals[1]<-sum(B[1,1])/(sum(B[1,1])+sum(B[1,-1]))
sensitivityVals[2]<-sum(B[2,2])/(sum(B[2,2])+sum(B[2,-2]))
sensitivityVals[3]<-sum(B[3,3])/(sum(B[3,3])+sum(B[3,-3]))
sensitivityVals[4]<-sum(B[4,4])/(sum(B[4,4])+sum(B[4,-4]))
sensitivityVals<-as.data.frame(sensitivityVals)
colnames(sensitivityVals) <- c("BLI","EXH","INH","INT")
print("Sensitivity per class (%):")
print(t(sensitivityVals*100),digits = 4)


specificityVals<-matrix(NA,1,4)
specificityVals[1]<-sum(B[-1,-1])/(sum(B[-1,-1])+sum(B[-1,1]))
specificityVals[2]<-sum(B[-2,-2])/(sum(B[-2,-2])+sum(B[-2,2]))
specificityVals[3]<-sum(B[-3,-3])/(sum(B[-3,-3])+sum(B[-3,3]))
specificityVals[4]<-sum(B[-4,-4])/(sum(B[-4,-4])+sum(B[-4,4]))
specificityVals<-as.data.frame(specificityVals)
colnames(specificityVals) <- c("BLI","EXH","INH","INT")
print("Specificity per class (%):")
print(t(specificityVals*100),digits = 4)


precisionVals<-matrix(NA,1,4)
precisionVals[1]<-sum(B[1,1])/(sum(B[1,1])+sum(B[-1,1]))
precisionVals[2]<-sum(B[2,2])/(sum(B[2,2])+sum(B[-2,2]))
precisionVals[3]<-sum(B[3,3])/(sum(B[3,3])+sum(B[-3,3]))
precisionVals[4]<-sum(B[4,4])/(sum(B[4,4])+sum(B[-4,4]))
precisionVals<-as.data.frame(precisionVals)
colnames(precisionVals) <- c("BLI","EXH","INH","INT")
print("Precision per class(%):")
print(t(precisionVals*100),digits = 4)



accuracyVals<-matrix(NA,1,4)
accuracyVals[1]<-(sum(B[1,1])+sum(B[-1,-1]))/(sum(B))
accuracyVals[2]<-(sum(B[2,2])+sum(B[-2,-2]))/(sum(B))
accuracyVals[3]<-(sum(B[3,3])+sum(B[-3,-3]))/(sum(B))
accuracyVals[4]<-(sum(B[4,4])+sum(B[-4,-4]))/(sum(B))
accuracyVals<-as.data.frame(accuracyVals)
colnames(accuracyVals) <- c("BLI","EXH","INH","INT")
print("Accuracy per class (%):")
print(t(accuracyVals*100),digits = 4)

Acc<-(B[1,1]+B[2,2]+B[3,3]+B[4,4])/sum(B)

print("Accuracy overall (%):")
print(t(Acc*100),digits = 4)





rm(list = ls())
suppressWarnings(suppressMessages(library("caret")))
B <- matrix(c(126, 3, 10, 57, 0, 34,1,128,5,10,182,31,49,38,11,523),nrow=4, ncol=4)
B<-as.data.frame(B)

REFV<-c(as.vector(matrix(1,1,sum(B[1,]))),
        as.vector(matrix(2,1,sum(B[2,]))),
        as.vector(matrix(3,1,sum(B[3,]))),
        as.vector(matrix(4,1,sum(B[4,]))))

ESTV<-c(
        as.vector(matrix(1,1,sum(B[1,1]))),
        as.vector(matrix(2,1,sum(B[1,2]))),
        as.vector(matrix(3,1,sum(B[1,3]))),
        as.vector(matrix(4,1,sum(B[1,4]))),
        as.vector(matrix(1,1,sum(B[2,1]))),
        as.vector(matrix(2,1,sum(B[2,2]))),
        as.vector(matrix(3,1,sum(B[2,3]))),
        as.vector(matrix(4,1,sum(B[2,4]))),
        as.vector(matrix(1,1,sum(B[3,1]))),
        as.vector(matrix(2,1,sum(B[3,2]))),
        as.vector(matrix(3,1,sum(B[3,3]))),
        as.vector(matrix(4,1,sum(B[3,4]))),
        as.vector(matrix(1,1,sum(B[4,1]))),
        as.vector(matrix(2,1,sum(B[4,2]))),
        as.vector(matrix(3,1,sum(B[4,3]))),
        as.vector(matrix(4,1,sum(B[4,4])))
)

CCC<-confusionMatrix(ESTV,REFV)
print(CCC)
