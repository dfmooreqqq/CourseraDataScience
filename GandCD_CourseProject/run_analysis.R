#load in needed libraries
library(reshape2)

#Read in files
labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")
train_x<-read.table("train/X_train.txt")
train_y<-read.table("train/y_train.txt")
train_subject<-read.table("train/subject_train.txt")
test_x<-read.table("test/X_test.txt")
test_y<-read.table("test/y_test.txt")
test_subject<-read.table("test/subject_test.txt")

#Label the various columns - this is for step 3
#Here, I'm using the make.names() formula to create good (without special characters) unique names for the data
#Most of the names don't change significantly, however there is some coding to deal with names that otherwise wouldn't be
#unique. These are addressed in the code book
goodnames<-make.names(features$V2, unique=TRUE)
nameconversionlookup <-cbind(as.character(features$V2), goodnames)
names(test_x)<-goodnames
names(train_x)<-goodnames
names(labels)<-c("ActivityNum", "ActivityLabel")
names(test_y)<-"ActivityNum"
names(train_y)<-"ActivityNum"
names(test_subject)<-"Subject"
names(train_subject)<-"Subject"

##bind the test and training data sets into each data sets
testdataset <- cbind(test_x, test_y, test_subject)
traindataset <- cbind(train_x, train_y, train_subject)
testdataset$DataSet <- "Test"
traindataset$DataSet <- "Train"

#now put the full datasets together
fulldataset<-rbind(testdataset, traindataset)

#define columns to keep in step 2 where we extract only the measurements on mean and std
#Note: I am specifically excluding the meanFreq columns from the tidy dataset
greplstring = "std|mean[^Freq]|ActivityNum|Subject|DataSet"
meanstddataset<-fulldataset[,which(grepl(greplstring,names(fulldataset)))]



#Merges the Activity labels onto the dataset
meanstddatasetw_labels<-merge(meanstddataset, labels)


#Use Melting and dcasting from the reshape2 library to get the mean for each numeric column by ActivityLabel and Subject
numericcol<-names(meanstddatasetw_labels[,sapply(meanstddatasetw_labels, is.numeric)])[-1][-80] #I need the -1 so that ActivityNum isn't included
tablemelt<-melt(meanstddatasetw_labels, id=c("ActivityNum", "ActivityLabel", "Subject"), measure.vars=numericcol)
avgtable <- dcast(tablemelt, ActivityLabel+Subject~variable, mean)

#clean up some variables that I'm done with
suppressWarnings(rm("features","goodnames", "test_subject", "test_x", "test_y", "testdataset", "train_subject", "train_x", "train_y", "traindataset", "greplstring", "labels", "meanstddataset", "tablemelt"))

#write the files out to the wd
nameconversionlookup<-data.frame(nameconversionlookup)
names(nameconversionlookup)<-c("origName", "RFriendlyName")
write.csv(avgtable, 'tidy_data_Averages.txt') #for uploading
write.csv(avgtable, 'tidy_data_Averages.csv') #with nice .csv extension
write.csv(nameconversionlookup, 'nameconversionlookup.csv')
write.csv(meanstddatasetw_labels, 'meanstddatasetw_labels.csv')