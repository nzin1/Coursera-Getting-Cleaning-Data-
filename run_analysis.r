#download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ","Dataset.zip", mode="wb")
#unzip("Dataset.zip")

#set working path
dir <- file.path("./" , "UCI HAR Dataset")

#Read the Activity files
activityTest  <- read.table(file.path(dir, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(dir, "train", "Y_train.txt"),header = FALSE)

#Read the Subject files
subjectTrain <- read.table(file.path(dir, "train", "subject_train.txt"),header = FALSE)
subjectTest  <- read.table(file.path(dir, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files
featuresTest  <- read.table(file.path(dir, "test" , "X_test.txt" ),header = FALSE)
featuresTrain <- read.table(file.path(dir, "train", "X_train.txt"),header = FALSE)

#1. Concatenate the data tables by rows (training and test sets)
subject <- rbind(subjectTrain, subjectTest)
activity<- rbind(activityTrain, activityTest)
features<- rbind(featuresTrain, featuresTest)

#set names to variables
names(subject)<-c("subject")
names(activity)<- c("activity")
#load features' heading
featuresNames <- read.table(file.path(dir, "features.txt"),head=FALSE)
names(features)<- featuresNames$V2

#3.Merge columns to get the data frame Data for all data
dataCombine <- cbind(subject, activity)
Data <- cbind(features, dataCombine)

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
matches<-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
selectedNames <-c(as.character(matches), "subject", "activity" )

#3 Uses descriptive activity names to name the activities in the data set
Data<-subset(Data,select=selectedNames)

#4 Appropriately labels the data set with descriptive variable names. 
# Change t to Time, f to Frequency
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]

write.table(Data2, file = "averages_data.txt",row.name=FALSE)


