setwd("C:\\Users\\Daniel\\Documents\\GitHub\\PML_CourseProject")
setwd("C:\\Users\\damoore\\Documents\\GitHub\\PML_CourseProject")

library(caret);library(Hmisc);library(plyr); library(data.table); library(randomForest);

pml_training<-read.csv("pml-training.csv")
pml_testing<-read.csv("pml-testing.csv")

####
# According to the paper which describes this dataset (http://groupware.les.inf.puc-rio.br/har), they use a sliding window
# approach to detect and separate each movement measurements. Then the statistcs
# (mean, variance, skiness..) of measuremets in this window are calculated and
# stored in rows with new_window: yes value. Therefore, my first step is to
# filter out these records from the original dataset, followed by steps removing
# unrevelent time stamp, record_id, new_window, num_window and user_name
# features.
pml_training<-pml_training[pml_training$new_window=="yes",]
pml_training<-as.data.table(pml_training)
pml_training <- pml_training[, c("X", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "new_window", "num_window", "user_name") := NULL]
# Convert columns to numeric that should be
pml_training<-pml_training[, lapply(.SD, as.numeric), by=c("classe")]
pml_training$classe<-as.factor(pml_training$classe)

#Within the training set, let's split up so we can use machine learning to build
#and verify the model. Let's use 70% training and 30% testing, as usual
split_indices <- createDataPartition(pml_training$classe, p=0.7)
pml_training_train<-pml_training[split_indices$Resample1]
pml_training_test<-pml_training[-split_indices$Resample1]

# I'm concerned about columns with near zero variance and this will not help with machine learning models (or any models), so I'll remove those with the "nearZeroVar" function
nearzerovar<-nearZeroVar(pml_training_train, saveMetrics=TRUE)
pml_training_train<-pml_training_train[,!nearzerovar$nzv, with = FALSE] #with = FALSE lets me select column names dynamically
pml_training_test<-pml_training_test[,!nearzerovar$nzv, with = FALSE]


# Now I'll impute the missing values by preprocessing the data using k-nearest neighbors. Default is k=5. I'm going to use BoxCox, KNN, PCA, as well as center and scale
# First separate the classe variable
pml_training_train_classe<-pml_training_train$classe
pml_training_test_classe<-pml_training_test$classe
preprocessed_train<-preProcess(pml_training_train[,-1, with = FALSE], method=c("BoxCox", "center", "scale", "knnImpute", "pca"), thresh = 0.95, k=5)
pml_training_train<-predict(preprocessed_train, newdata=pml_training_train[, -1, with = FALSE])
pml_training_test<-predict(preprocessed_train, newdata=pml_training_test[, -1, with = FALSE])


# I want to use Random Forest, that is, bagging, for building a model. I'll apply 5 repeats and 5 resampling iterations.
rf_control<-trainControl(method="repeatedcv", number=20, repeats=20)
rf_grid<-expand.grid(mtry=1:10)
rf_model<-train(pml_training_train, pml_training_train_classe, method="rf", trControl=rf_control, tuneGrid=rf_grid, metric="Accuracy")
plot(rf_model)
rf_testing_classe<-predict(rf_model, newdata=pml_training_test)
rf_confusion<-confusionMatrix(rf_testing_classe, pml_training_test_classe)
rf_confusion$table
rf_confusion$overall


# I also want to look at using Boosting. Because of computation time, I'm only going to do 5 repeats and 5 resampling
boost_control<- trainControl(method="repeatedcv", number=10, repeats=10)
boost_grid<- expand.grid(interaction.depth = c(1,2,3,4,5,6), n.trees=1:30*9, shrinkage = 0.1)
boost_model<- train(pml_training_train, pml_training_train_classe, method="gbm", trControl = boost_control, tuneGrid = boost_grid, metric="Accuracy", verbose=FALSE)
plot(boost_model)
boost_testing_classe<-predict(boost_model, newdata=pml_training_test)
boost_confusion<-confusionMatrix(boost_testing_classe, pml_training_test_classe)
boost_confusion$table
boost_confusion$overall

comparison<-as.data.frame(rbind(rf_model=rf_confusion$overall, boost_model=boost_confusion$overall))


# Comparing Boost to RF, RF has better accuracy, so I'm going to use that.
# First we have to make the transformations to the test data that we made to the training data
pml_testing<-as.data.table(pml_testing)
pml_testing <- pml_testing[, c("X", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "new_window", "num_window", "user_name") := NULL]
# Convert columns to numeric that should be
pml_testing<-pml_testing[, lapply(.SD, as.numeric), by=c("problem_id")]
pml_testing<-pml_testing[,!nearzerovar$nzv, with = FALSE] #with = FALSE lets me select column names dynamically
pml_testing_id<-pml_testing$problem_id
pml_testing_preprocessed<- predict(preprocessed_train, newdata=pml_testing[,-1,with=FALSE])
pml_testing_submit_classe3<- predict(rf_model, newdata=pml_testing_preprocessed)


## Let's see what it looks like with the GBM model
gbm_pml_testing_submit_classe3<- predict(boost_model, newdata=pml_testing_preprocessed)




### Submit files
source('pml_write_files.R')
pml_write_files(as.character(pml_testing_submit_classe))

