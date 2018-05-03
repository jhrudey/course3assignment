Code Book for run_analysis.R and df_final.txt

Variables list
"activitylabel": the activity being carried out when the measurements were taken
"testtrain": an indicator of whether the subject was part of the test group or the training group
"subjectid": ID of the participant

The remaining variables represent the means of all measurements per participant per activity. The variables that were extracted from the raw data for this purpose consisted of all variables with the mean() token in the variable name, the std() token in the variable name and the meanFreq() token in the variable name. For details about what the specific variables represent see: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
and the original raw data here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Data manipulations to create tidy dataset:
Step 1. features.txt was read into R and the text in this dataframe was modified so that all letters were changed to lower case and the unneccesary special characters "-" and "()" were removed. 
Step 2. Data from x_test.txt, y_test.txt, subject_test.txt, x_train.txt, y_train.txt and subject_train.txt were read into R
Step 2. The data from features were modified to a character vector and used to give variable names to the measurements of x_test.
Step 3. subject_test was labelled with the name "subjectid"
Step 4. y_test was labelled with the name "activitylabel" and the codes for the activities were coded as follows:
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING
Step 5. A matrix was created to make a variable indicator for the test cases
Step 6. A complete dataframe of the test data was made using cbind to bind the columns from subject_test, test, y_test and x_test dataframes together
Step 7. The process was repeated for the data x_train, y_train and subject_train, to make the indicator variable for the training cases and to combine the data into one training dataframe
Step 8. rbind was used to combine the complete test and train dataframes into one raw dataframe
Step 9. The required variables were selected to create a raw dataset of the subjectids, activity labels, test or training indicators, and the measurements with the tokens mean(), std() and meanFreq() in the variable name
Step 10. this raw dataframe melted into a long dataframe so that all the different measurements per participant were stacked on top of one another
Step 11. dcast was applied to the long dataframe to create a wide dataset with a mean value for the selected measurements per subject per activity and a tab-deliminated text file was created from the final tidy dataframe
Step 12. the unneccessary data was deleted from the harddrive
