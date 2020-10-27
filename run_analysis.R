

#Requires dplyr package

library(dplyr)

#Change wd, to read easy the files

setwd("C:/Users/juanfidel18/Desktop/Coursera/cleaningdata")

# activity labels + features

features_list <- read.table("features.txt", col.names = c("no","features"))
activity <- read.table("activity_labels.txt", col.names = c("label", "activity"))

# dataset and combine into one dataframe

subject_test <- read.table("subject_test.txt", col.names = "subject")
x_test <- read.table("X_test.txt", col.names = features_list$features)
y_test <- read.table("Y_test.txt", col.names = "label")
y_test_label <- left_join(y_test, activity, by = "label")
tidy_test <- cbind(subject_test, y_test_label, x_test)
tidy_test <- select(tidy_test, -label)

# Read train dataset

subject_train <- read.table("subject_train.txt", col.names = "subject")
x_train <- read.table("X_train.txt", col.names = features_list$features)
y_train <- read.table("Y_train.txt", col.names = "label")
y_train_label <- left_join(y_train, activity, by = "label")
tidy_train <- cbind(subject_train, y_train_label, x_train)
tidy_train <- select(tidy_train, -label)

# Merge_test & train data

tidy_set <- rbind(tidy_test, tidy_train)

# Extract mean and standard deviation of tidy_set

tidy_mean_std <- select(tidy_set, contains("mean"), contains("std"))

# Averanging all variable by each subject each activity

tidy_mean_std$subject <- as.factor(tidy_set$subject)
tidy_mean_std$activity <- as.factor(tidy_set$activity)
tidy_avg <- tidy_mean_std %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# WRITE TXT

write.table(tidy_avg,file="Tidydata.txt")


