# CodeBook/Documentation for Coursera's *Getting and Cleaning Data* Course Project
## *Prepared by Jordan Grimstad on 12/26/2015*

## Overview
This CodeBook describes the variables, data, and transformations/work performed as prescribed by Coursera's *Getting and Cleaning Data* course project.

## Program Function by Section
### Section 1: Install and Load Necessary Packages
The {plyr} and {dplyr} packages are installed (if necessary) and loaded using the library() function.

### Section 2: Download and Unzip Data
.zip file containing the UCI HAR Dataset [link to data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "UCI HAR Dataset") is downloaded from [UCI's Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "UCI's Machine Learning Repository"). 

The .zip file is unzipped to the /data directory in the user's working directory.

### Section 3: Read Data
The following variables are created to store the read data from the unzipped .txt files of the same name:
* *subject_test* - includes number associated with each subject involved in "test" group
* *X_test* - includes observations for each subject/activity pair in "test" group
* *y_test* - includes labels for activities performed for each observation in "test" group
* *subject_train* - includes number associated with each subject involved in "train" group
* *X_train* - includes observations for each subject/activity pair in "train" group
* *y_train* - includes labels for activities performed for each observation in "train" group
These variables will be used to combine the data sets in later steps.

### Section 4: Renaming Variables to Descriptive Names
The "features.txt" file, which details the names of each variable in the *X_test* and *X_train* data.frames, is read into a variable called *features*. This variable is then reassigned to a vector of just the names of the variables (accomplished by extracting the second column of the data.frame and transforming it using as.vector()). Then, three groups of variables are renamed:
1. The variable names (colnames) of *X_test* and *X_train* are both renamed to the names included in the *features* vector.
2. The variable name (colnames) of *subject_test* and *subject_train* are both renamed to "Subject.Number"
3. The variable name (colnames) of *y_test* and *y_train* are both renamed to "Activity"

### Section 5: Consolidating Data & Merging the Datasets
The "test" and "train" data is merged together in three steps:
1. cbind() is used to combine *subject_test*, *y_test*, and *X_test*, the result is stored in the *test* data.frame; this keeps Subject.Number and Activity as the first two columns, and the remaining columns are observations for the 561 variables
2. cbind() is used to combine *subject_train*, *y_train*, and *X_train*, the result is stored in the *train* data.frame; same rationale applies as in step 1
3. rbind() is used to combine *test* and *train*, the result is stored in the *complete* data.frame; since the variables are in the same order in both datasets, and there is no overlap between the data in *test* and the data in *train*, the rows from one dataset can simply be appended to the rows of the other dataset without duplication/loss of data.

### Section 6: Renaming Activity Labels to Descriptive Names
The "Activity" observation in the *complete* data.frame is renamed to descriptive labels in three steps:
1. The "activity_labels.txt" file is read in using read.table and stored to a data.frame called *activities*
2. The "Activity" observation in the *complete* data.frame is transformed to a factor variable using as.factor()
3. mapvalues() is used to reassign the observations in the "Activity" observation from numbers (in the first column of *activities*, which has been vectorized in this step) to descriptive labels (in the second column of *activities*, which has been vectorized in this step)

### Section 7: Extracting Mean & Standard Deviation Data
The mean and standard deviation of the variables are extracted from the *complete* data.frame using sapply(), specifying the non-Subject.Number/Activity observations in the data.frame. These are assigned to the *measureMeans* and *measureStdev* variables, respectively.

### Section 8: Creating an Independent Tidy Dataset
To compute and store a list of means by subject by activity, the aggregate() function was used (with the "by" parameter specifying Subject.Number & Activity as the items to group by & FUN="mean"). This was applied to the non-Subject.Number/Activity columns (as in Section 7), and the result was stored in a data.frame called *subjectActivityMean*. The rename() function was then used to change the grouping names in columns 1 and 2 back to "Subject.Number" and "Activity," respectively.

Finally, *subjectActivityMean* is written to "wearableData.txt" in the working directory to complete the creation of this independent, tidy dataset.

## Resources used in completing this project
* (Documentation for unzip function)[https://stat.ethz.ch/R-manual/R-devel/library/utils/html/unzip.html]
* (Documentation for sd function)[https://stat.ethz.ch/R-manual/R-devel/library/stats/html/sd.html]
* (Renaming Levels of a Factor, R Cookbook](http://www.cookbook-r.com/Manipulating_data/Renaming_levels_of_a_factor/)
* (StackOverflow, addressing an error that arose with rename())[http://stackoverflow.com/questions/26371279/dplyr-0-3-0-2-rename-idiom-unstable-when-reshape-package-is-loaded]
* Coursera's discussion forums for *Getting and Cleaning Data* course
