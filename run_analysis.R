# run_analysis.R

#Getting and Cleaning Data Course Project

# run_analysis.R will run the following actions on the UCI HAR Dataset:

# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
setwd("UCI HAR Dataset")
library(plyr)
packageVersion("plyr")


# 1. Merge the training and the test sets to create one data set.

testData <- read.table("./test/X_test.txt")
testLabel <- read.table("./test/y_test.txt")
testSubject <- read.table("./test/subject_test.txt")

trainData <- read.table("./train/X_train.txt")
trainLabel <- read.table("./train/y_train.txt")
trainSubject <- read.table("./train/subject_train.txt")

# combine x data matrix
Data <- rbind(testData,trainData)

# combine y data vector
DataLabel <- rbind(testLabel, trainLabel)

# combine subject data vector
DataSubject <- rbind(testSubject,trainSubject)


# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./features.txt")
meanSTD <- grep("mean\\(\\)|std\\(\\)",features[,2])
Data <- Data[, meanSTD]
names(Data) <- features[meanSTD,2]
names(Data) <- gsub("mean","Mean", names(Data))
names(Data) <- gsub("Std","StdDev", names(Data))
names(Data) <- gsub("-","",names(Data))
names(Data) <- gsub("\\(\\)","",names(Data))
names(Data) = gsub("^(t)","time",names(Data))
names(Data) = gsub("^(f)","freq",names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

# 3. Use descriptive activity names to name the activities in the data set
activity <- read.table("./activity_labels.txt")
activity[,2] <- gsub("_","", activity[,2])
activityLabel <- activity[DataLabel[,1],2]
DataLabel[,1] <- activityLabel
names(DataLabel) <- "Activity"

# 4. Appropriately label the data set with descriptive activity names. 
names(DataSubject) <- "Subject"
CleanData <- cbind(DataSubject,DataLabel,Data)
write.table(CleanData,"CleanData.txt", row.name= FALSE)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
Tidy_data = ddply(CleanData, c("Subject","Activity"), numcolwise(mean))
write.table(Tidy_data, file = "Tidy_data.txt")
