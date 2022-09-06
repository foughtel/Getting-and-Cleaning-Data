
##load reshape2 into R
library(reshape2)


zipfile <- "final_project_data.zip"

## Look for data, if it doesn't exist, download it
if (!file.exists(zipfile)){dir.create("./data")}
fileURL <- fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, zipfile, method="curl")
 
if (!file.exists("UCI HAR Dataset")) { 
  unzip(zipfile) 
}

##Creating lists for the labels/codebook
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
featuresList <- read.table("UCI HAR Dataset/features.txt")
featuresList[,2] <- as.character(featuresList[,2])

#Sort and filter the features list for only mean and std
featuresWanted <- grep(".*mean.*|.*std.*", featuresList[,2])
featuresNames <- featuresList[featuresWanted,2]


# Create variables from *train txt files
trainfeatures <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainactivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubjects, trainactivities, trainfeatures)

## Create variables from *test txt files
testfeatures <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testactivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubjects, testactivities, testfeatures)

## Use rbind to combine the train and test
Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", featuresNames)

##Appropriately label everything more clearly
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Create factors from activity and subject
Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Data$subject <- as.factor(Data$subject)

##Melt data and get mean for each subject/activity combo
dataMelt <- melt(Data, id = c("subject", "activity"))
dataMean <- dcast(dataMelt, subject + activity ~ variable, mean)

write.table(dataMean, "tidy.txt", row.names = FALSE, quote = FALSE)