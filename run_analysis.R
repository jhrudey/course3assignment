#course 3 assignment

#set the working directory for download

setwd("/users/jhrudey/Desktop/Courses/Datasciencecoursera")
if (!file.exists("course3assignment")) {
  dir.create("course3assignment")
}

#download and unzip the files

dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, "./course3assignment/course3assignment.zip")
datedownloaded <- date()
unzip("./course3assignment/course3assignment.zip", exdir = "./course3assignment")

list.files("./course3assignment")

#reset the working directory to the location of the assignment files

setwd("/users/jhrudey/Desktop/Courses/Datasciencecoursera/course3assignment/UCI HAR Dataset")

#look at the features to see if this is supposed to be the variable names for the X data from train and test

list.files("./")

features <- read.table("./features.txt", colClasses = c("NULL", NA))
dim(features)
head(features)

#correct the text so that there are only lower case letters and without the - and () values

features$V2 <- tolower(features$V2)
features$V2 <- gsub("-","",features$V2)
features$V2 <- sub("\\()","",features$V2)
head(features)

#look at the dimensions of the test data to see how it fits together

list.files("./test")

x_test <- read.table("./test/X_test.txt")
dim(x_test)

y_test <- read.table("./test/y_test.txt")
dim(y_test)

subject_test <- read.table("./test/subject_test.txt")
dim(subject_test)

#looks like there are 2947 total measurements across 561 features; each feature will need to be 
#the column names for X_test

#look at the dimensions of the train data to see how it fits together

list.files("./train")

x_train <- read.table("./train/X_train.txt")
dim(x_train)

y_train <- read.table("./train/y_train.txt")
dim(y_train)

subject_train <- read.table("./train/subject_train.txt")
dim(subject_train)

#same as above with the test, but now 7352 measurements in total

#add the information from features to the x_test.txt file to provide the names

colnames(x_test) <-as.vector(t(features$V2))
head(x_test)
tail(x_test)

#give names to the subject_test and y_test datasets

colnames(subject_test) <- c("subjectid")
head(subject_test)

colnames(y_test) <- c("activitylabel")
head(y_test)

#label the activity levels
#Activity labels
#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING

y_test$activitylabel <- factor(y_test$activitylabel, 
                               levels = c(1,2,3,4,5,6),
                               labels = c("WALKING","WALKING UPSTAIRS","WALKING DOWNSTAIRS","SITTING","STANDING","LAYING"))


levels(y_test$activitylabel)

#make a variable to label whether you are dealing with a test case or a training case

test <- matrix("test", nrow = 2947, ncol = 1)
colnames(test) <-"testtrain"
head(test)
tail(test)

#combine the test datasets into one

test_final <- cbind(subject_test, test, y_test, x_test)
head(test_final)

#repeat entire process for training data

colnames(x_train) <-as.vector(t(features$V2))
head(x_train)
tail(x_train)

#give names to the subject_test and y_test datasets

colnames(subject_train) <- c("subjectid")
head(subject_train)

colnames(y_train) <- c("activitylabel")
head(y_train)

#label the activity levels
#Activity labels
#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING

y_train$activitylabel <- factor(y_train$activitylabel, 
                               levels = c(1,2,3,4,5,6),
                               labels = c("WALKING","WALKING UPSTAIRS","WALKING DOWNSTAIRS","SITTING","STANDING","LAYING"))


levels(y_train$activitylabel)

#make a variable to label whether you are dealing with a test case or a training case

train <- matrix("train", nrow = 7352, ncol = 1)
colnames(train) <-"testtrain"
head(train)
tail(train)

#combine the test datasets into one

train_final <- cbind(subject_train, train, y_train, x_train)
head(train_final)

#make one dataset of the training and test data

raw_df_temp <- rbind(train_final, test_final)
head(raw_df_temp)

#select the variables that refer to mean and standard deviation

raw_df <-raw_df_temp[, c(1:9, 44:49, 84:89, 124:129, 164:169, 204, 205, 217, 218, 230, 231, 243, 244, 256, 257, 
                         269:274, 297:299, 348:353, 376:378, 427:432, 455:457, 506, 507, 514, 519, 520, 529,
                         532, 533, 542, 545, 546, 555)]
head(raw_df)
dim(raw_df)
# the number of columns is correct. There are 33 variables with mean(), 33 variables with std(),
#13 variables with meanFreq() and 2 variables for subjectid and activitylevel. I did not include the angular
#variables with mean in the name as these appear to be futher calculations based on means, rather than means themselves


#reshape the data so that it is tidy

library(reshape)
library(reshape2)

#melt the dataset to create a long file with all the individual measurements per subject
#stacked into a long file

df_melt <- melt(raw_df, id=c("subjectid","activitylabel","testtrain"))
head(df_melt)

#restructure this long file into a wide file that contains the means of each variable
#for each subject within each activity level

df_final <-dcast(df_melt, activitylabel + testtrain + subjectid~variable, mean)
head(df_final)
tail(df_final)

#arrange the file according to subjectid

library(dplyr)

df_final <- arrange(df_final, subjectid)
head(df_final)

#export the final dataframe

setwd("/users/jhrudey/Desktop/Courses/Datasciencecoursera")

write.table(df_final, "./course3assignment/df_final.txt", sep="\t")

#delete the unneccessary files

file.remove("./course3assignment/course3assignment.zip")
unlink("./course3assignment/UCI HAR Dataset", recursive = TRUE)
