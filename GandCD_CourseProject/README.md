# Getting & Cleaning Data - Course Project

## How to run
The following files are required in the working directory of R in order to run:
* activity_labels.txt : Links the class labels with their activity name.
* features.txt : List of all features
* train/X_train.txt : Training set
* train/y_train.txt : Training labels
* train/subject_train.txt : Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
* test/X_test.txt : Test set
* test/y_test.txt : Test labels.
* test/subject_test.txt : Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

### To run
1. In R, set the working directory to be the directory containing the files and folders listed above using the setwd() command
2. Run 'run_analysis.R' using source('run_analysis.R') pointing to the 'run_analysis.R' file.

## The output
After running, the following variables should exist in the global environment
* avgtable - the tidy data set described in step 7 below
* fulldataset - the original full data set with R friendly names - created in step 3 below
* meanstddatasetw_labels - the data set containing the mean and std columns with activity labels, subject number, and a column indicating which data set it is a part of (Test or Train) - created in step 5 below
* nameconversionlookup - a matrix with 2 columns. The first column is the original column name. The second column is the R friendly unique column name created by make.names()

And the following csv files are created in the working directory
* tidy_data_Averages.csv - equivalent to avgtable
* meanstddatasetw_labels.csv - equivalent to meanstddatasetw_labels
* nameconversionlookup.csv - equivalent to nameconversionlookup
* *fulldataset is not saved as a csv due to size considerations (would be approximately 65 MB)*


## What the script does
The script has several steps outlined in the comments of the script code.

1. read in the data files
2. using the 'features.txt' file we convert the names to an R-friendly format using *make.names()* and then apply those names to the testing and training data
3. We then bind the testing and training data sets together
4. Since we are only interested in measurements of the mean and std of values, we subset the data to contain only those columns in addition to some labelling columns (ActivityNum, Subject, and which Dataset it is a part of). *Note: This specifically does not include the meanFreq columns*
5. Using *merge()*, we add the activity labels onto the data set
6. Using *melt()* and *dcast()* from the reshape2 library, we get the mean for each numeric column by each activity label and subject,
7. This table (stored as 'avgtable') is the tidy data set.
8. Three of the files are then output to csv data sets - tidy_data_Averages.csv is the tidy data set, nameconversionlookup.csv contains the conversion of names from 'features.txt' to their final format, and 'meanstddatasetw_labels.csv' is the full data set with just the mean and std columns.


## What commands are used
Most of the commands used are in the base R package (such as read.table, names, cbind, rbind, make.names, merge, grepl, and rm). A couple of commands are used from the reshape2 library. These are melt and dcast.

## Codebook help
The codebook, contained in the file "codebook.md", contains the description of the tidy data set. This has the specific labelling of the columns and a description of the summary values given.
