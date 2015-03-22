# Run Analysis R
# 1. merges the training and test sets to create one data set.
# 2. extracts the measurements on the mean and std dev for each measurement.
# 3. uses descriptive activity names to name the activities in the data set
# 4. appropriately labels the data set with descriptive variable names
# 5. from the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.
#the codebook is embedded within this text
#the final variables include the subject number, the activity the subject was performing, 
#the variable (i.e. mean and std deviation of measurement type)  The dimensions of the table are 88 variables 
#and 1934 observations because incomplete observations are omitted. Soft wrap for ease of reading.


#1 Merge the training and test sets to create one data set and #3, 
#use descriptive activity names to name the activities in the data set, 
#and #4 appropriately labels the data set with descriptive variable names

X_train <- read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)

X_test <- read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE)

library(tidyr)
library(dplyr)
library(reshape2)
library(data.table)

X_all <- bind_rows(X_train, X_test) #add all the training and test data together
View(X_all)

#name the columns something reasonable
features <- read.table("~/Downloads/UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE)
View(features)
names(X_all) = features$V2

subject_train <- read.table("~/Downloads/UCI HAR Dataset/train/subject_train.txt", quote="\"", stringsAsFactors=FALSE)
subject_test <- read.table("~/Downloads/UCI HAR Dataset/test/subject_test.txt", quote="\"")

subject_all <- bind_rows(subject_train, subject_test) #combine as before in the x train and test sets

activity_labels <- read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt", quote="\"", stringsAsFactors=FALSE)

View(activity_labels)

subject_activity <- full_join(subject_all, activity_labels) 
#descriptive activity names for all the activities in the data set on each subject

subject.no <- subject_activity$V1
activity <- subject_activity$V2
subject.activity <- data.frame(subject.no, activity)
all_data <- cbind(as.data.table(X_all),(subject_activity))

#there are now two complete, corresponding data frames,
#one with all the X data and one with all the subject activity data by number and label

#join the y data now to make one large data set

y_train <- read.table("~/Downloads/UCI HAR Dataset/train/y_train.txt", quote="\"", stringsAsFactors=FALSE)
y_test <- read.table("~/Downloads/UCI HAR Dataset/train/y_train.txt", quote="\"", stringsAsFactors=FALSE)

y_all <- bind_rows(y_train, y_test) #add all the training and test data together
View(y_all)

#just for good measure I create .csv output files to 
#save and check data or to send to those who prefer other data analysis methods

write.csv(all_data, "all_data.csv")
write.csv(subject_activity, "subject_activity.csv")
write.csv(y_all, "all_y_data.csv")

#2. & #4 Extracts measurements on the mean and std for each measurement; labels correctly with descriptive name

#The first 6 columns in the all_data set have the mean and std, the rest are other measurements or quantiles.  
#Below is a new data set giving just these measurements.


mean <- select(all_data, contains("mean"))
std <- select(all_data, contains("std"))
mean.std <- cbind(as.data.table(mean),(std))
mean.std.subject.activity <- cbind(as.data.table(mean.std), (subject.activity))

write.csv(mean.std.subject.activity, "mean.std.subject.activity.csv")

#5 Create a tidy data set with average of each variable for each activity by each subject

tidy <- na.omit(mean.std.subject.activity) 
#data set has no missing variables and contains all the means (averages) and standard deviation 
#for each subject by activity in which they participated

write.table(tidy, row.name=FALSE, "tidy.txt")
