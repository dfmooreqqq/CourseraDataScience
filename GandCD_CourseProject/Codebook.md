# Codebook for Tidy Data Set
The full features read in to the data are described in the 'feature_info.txt' file provided with the data set. A subset of these variables is included in the tidy_data_Averages.csv

## Column labelling format
 1. The first column in tidy_data_Averages.csv gives the row number (1-180).
 2. The second column is labelled 'ActivityLabel' and is "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"
 3. The third column is labelled 'Subject' and takes values of 1-30, representing the subject that was tested for that record.
 4. The rest of the columns of tidy_data_Averages.csv are labelled in the following format: **<signal>.<estimate>...<X, Y, or Z direction>** where estimate is either "mean" or "std" and signal is one of the following (the -XYZ indicates that there is a column for the X, Y, and Z direction for this signal):
  * tBodyAcc-XYZ
  * tGravityAcc-XYZ
  * tBodyAccJerk-XYZ
  * tBodyGyro-XYZ
  * tBodyGyroJerk-XYZ
  * tBodyAccMag
  * tGravityAccMag
  * tBodyAccJerkMag
  * tBodyGyroMag
  * tBodyGyroJerkMag
  * fBodyAcc-XYZ
  * fBodyAccJerk-XYZ
  * fBodyGyro-XYZ
  * fBodyAccMag
  * fBodyAccJerkMag
  * fBodyGyroMag
  * fBodyGyroJerkMag

## Values given
For each Activity and Subject, the values in the column are the average mean or average standard deviation in the fulldataset (containing both the training and the test data)
**All of the values are based on data that has been normalized for each metric to have values between -1 and 1. This is how values that represent a std can be negative.**