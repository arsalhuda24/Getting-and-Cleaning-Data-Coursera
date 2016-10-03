features<- read.table("features.txt", header = FALSE)
activity_labels<- read.table("activity_labels.txt", header = FALSE)
subject_test<-read.table("./test/subject_test.txt", header = FALSE)
subject_train<-read.table("./train/subject_train.txt", header = FALSE)

xtest<-read.table("./test/X_Test.txt", header = FALSE)
ytest<-read.table("./test/Y_Test.txt", header = FALSE)
colnames(xtest)<- features[,2]
colnames(ytest)<-"Activity_ID"
colnames(subject_test)<- "Subject_ID"
testdata<-cbind(subject_test,ytest,xtest)

xtrain<-read.table("./train/X_train.txt", header = FALSE)
ytrain<-read.table("./train/Y_train.txt", header = FALSE)
colnames(xtrain)<- features[,2]
colnames(ytrain)<-"Activity_ID"
colnames(subject_train)<- "Subject_ID"
traindata<-cbind(subject_train,ytrain,xtrain)

alldata<- rbind(traindata,testdata)

a<-(grepl("mean",names(alldata))| grepl("std",names(alldata)))
reqdata<-alldata[a==TRUE]

alldata$Activity_ID <- as.character(alldata$Activity_ID)
alldata$Activity_ID[alldata$Activity_ID == 1] <- "Walking"
alldata$Activity_ID[alldata$Activity_ID == 2] <- "Walking Upstairs"
alldata$Activity_ID[alldata$Activity_ID == 3] <- "Walking Downstairs"
alldata$Activity_ID[alldata$Activity_ID == 4] <- "Sitting"
alldata$Activity_ID[alldata$Activity_ID == 5] <- "Standing"
alldata$Activity_ID[alldata$Activity_ID == 6] <- "Laying"
alldata$Activity_ID <- as.factor(alldata$Activity_ID)

names(alldata) <- gsub("Acc", "Accelerator", names(alldata))
names(alldata) <- gsub("Mag", "Magnitude", names(alldata))
names(alldata) <- gsub("Gyro", "Gyroscope", names(alldata))
names(alldata) <- gsub("^t", "time", names(alldata))
names(alldata) <- gsub("^f", "frequency", names(alldata))

tidydata<-alldata[order(alldata$Subject_ID),]

Master.dt <- data.table(Master)
#This takes the mean of every column broken down by participants and activities
TidyData <- Master.dt[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)










