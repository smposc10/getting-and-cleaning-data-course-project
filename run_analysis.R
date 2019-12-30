## --------------------- ##
## Preparing the Dataset ##
## --------------------- ##

## Deploy dplyr library to use later ##

library(dplyr)

## Get dataset ##


if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

# Dataset is in zip format so we need to unzip it. It should load the "UCI HAR Dataset" Folder #

unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Inspect the files inside the UCI HAR dataset #

targetPath <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(targetPath, recursive=TRUE)
files

## Read dataset ##

# Features #

features <- read.table(file.path(targetPath, "features.txt"), col.names = c("n", "functions"))

# Check Labels /Activities #

activities <- read.table(file.path(targetPath, "activity_labels.txt"), col.names = c("code", "activity"))


# Read Training Data #

trainSubjects <- read.table(file.path(targetPath, "train", "subject_train.txt"), col.names = c("subject"))
trainX <- read.table(file.path(targetPath, "train", "X_train.txt"), col.names = features$functions )
trainY <- read.table(file.path(targetPath, "train", "y_train.txt"), col.names = "code")

# Read Testing Data #

testSubjects <- read.table(file.path(targetPath, "test", "subject_test.txt"), col.names = c("subject"))
testX <- read.table(file.path(targetPath, "test", "X_test.txt"), col.names = features$functions)
testY <- read.table(file.path(targetPath, "test", "y_test.txt"), col.names = "code")


## --------------------------------------------------------------- ##
## Step 1: Merge the training and test sets to create one data set ##
## --------------------------------------------------------------- ##

subject <- rbind(trainSubjects, testSubjects)
xData <- rbind(trainX , testX)
yData <- rbind(trainY , testY)
mergedDataset <- cbind(subject, yData, xData)

## --------------------------------------------------------------------------------------------- ##
## Step 2: Extract only the measurements on the mean and standard deviation for each measurement ##
## --------------------------------------------------------------------------------------------- ##

tidyDataSet <- mergedDataset %>% select(subject, code, contains("mean"), contains("std"))

## -------------------------------------------------------------------------------------------- ##
## Step 3: Use descriptive activity names to name the activities in the data set.               ##
## -------------------------------------------------------------------------------------------- ##

tidyDataSet$code <- activities[tidyDataSet$code, 2]

## ------------------------------------------------------------------------------------------ ##
## Step 4: Appropriately label the dataset with descriptive variable names.                   ##
## ------------------------------------------------------------------------------------------ ##

names(tidyDataSet)[2] = "activity"
names(tidyDataSet)<-gsub("Acc", "Accelerometer", names(tidyDataSet))
names(tidyDataSet)<-gsub("Gyro", "Gyroscope", names(tidyDataSet))
names(tidyDataSet)<-gsub("Mag", "Magnitude", names(tidyDataSet))
names(tidyDataSet)<-gsub("^t", "Time", names(tidyDataSet))
names(tidyDataSet)<-gsub("^f", "Frequency", names(tidyDataSet))
names(tidyDataSet)<-gsub("-mean()", "Mean", names(tidyDataSet), ignore.case = TRUE)
names(tidyDataSet)<-gsub("-std()", "StandardDeviation", names(tidyDataSet), ignore.case = TRUE)
names(tidyDataSet)<-gsub("-freq()", "Frequency", names(tidyDataSet), ignore.case = TRUE)
names(tidyDataSet)<-gsub("angle", "Angle", names(tidyDataSet))
names(tidyDataSet)<-gsub("gravity", "Gravity", names(tidyDataSet))
names(tidyDataSet)<-gsub("BodyBody", "Body", names(tidyDataSet))
names(tidyDataSet)<-gsub("tBody", "TimeBody", names(tidyDataSet))

## ------------------------------------------------------------------------------------------------------------------------ ##
## Step 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. ##
## ------------------------------------------------------------------------------------------------------------------------ ##

tidyDataSummaryAvg <- tidyDataSet %>%  
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
write.table(tidyDataSummaryAvg, "tidyDataSummaryAvg.txt", row.name=FALSE)



