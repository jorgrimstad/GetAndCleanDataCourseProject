#install and load necessary packages
install.packages("plyr")
install.packages("dplyr")
library(plyr)
library(dplyr)

#download & unzip data - assumes that "data" directory exists
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "GACDdataset.zip", mode = "wb")
unzip("GACDdataset.zip")

#read data in using read.table
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Addressing task #4: renaming variables to descriptive names
features <- read.table("./UCI HAR Dataset/features.txt") #get names of observations in X_train and X_test datasets
features <- as.vector(features$V2) #create vector of names from features.txt
colnames(X_test) <- features #apply vector of observation names to test data
colnames(X_train) <- features #apply vector of observation names to train data
colnames(subject_test) <- c("Subject.Number") #change name from "V1" to "Subject.Number"
colnames(subject_train) <- c("Subject.Number") #change name from "V1" to "Subject.Number"
colnames(y_test) <- c("Activity") #change name from "V1" to "Activity"
colnames(y_train) <- c("Activity") #change name from "V1" to "Activity"

# Addressing task #1: merge the datasets
test <- cbind(subject_test, y_test, X_test) # consolidate the test data sets to prepare for data merge
train <- cbind(subject_train, y_train, X_train) # consolidate the training data sets to prepare for data merge
complete <- rbind(test, train) # combine the datasets using rbind() (there is no overlap in subjects between the data sets)

# Addressing task #3: renaming activities
activities <- read.table("./UCI HAR Dataset/activity_labels.txt") # create table showing activity labels/activity pairs
complete$Activity <- as.factor(complete$Activity) # changing to factor variable to prep for renaming
complete$Activity <- mapvalues(complete$Activity, 
                               from=as.vector(activities[,1]), 
                               to=as.vector(activities[,2])) # use plyr package to map "anonymous" activities to descriptive names

# Addressing task #2: extracting mean & standard deviation data for each variable using sapply, storing vector results to variables
measureMeans <- sapply(complete[,3:563], FUN=mean)
measureStdev <- sapply(complete[,3:563], FUN=sd)

# Addressing task #5: creating an independent, tidy data set showing mean of each variable by subject & activity
subjectActivityMean <- aggregate(complete[3:563], by=list(complete$Subject.Number, complete$Activity), FUN="mean")
subjectActivityMean <- dplyr::rename(subjectActivityMean, Subject.Number = Group.1, Activity = Group.2) #renaming first two columns
write.table(subjectActivityMean, "wearableData.txt", row.names = FALSE)


## Resources used to help with this assignment:
# https://stat.ethz.ch/R-manual/R-devel/library/utils/html/unzip.html
# https://stat.ethz.ch/R-manual/R-devel/library/stats/html/sd.html
# http://www.cookbook-r.com/Manipulating_data/Renaming_levels_of_a_factor/
# http://stackoverflow.com/questions/26371279/dplyr-0-3-0-2-rename-idiom-unstable-when-reshape-package-is-loaded
# Coursera's discussion forums for Getting and Cleaning Data course