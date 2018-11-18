#read all the files and rename them
activity_labels <- read.table("/Users/apple/Desktop/UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <-c("activity_id","activity_type")

features <-read.table("/Users/apple/Desktop/UCI HAR Dataset/features.txt")
colnames(features) <-c("feature_id","feature_type")

subject_test <-read.table("/Users/apple/Desktop/UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- c("subject_id")

subject_train <-read.table("/Users/apple/Desktop/UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- c("subject_id")

X_test <-read.table("/Users/apple/Desktop/UCI HAR Dataset/test/X_test.txt")
colnames(X_test) <- feature[,2]

y_test <- read.table("/Users/apple/Desktop/UCI HAR Dataset/test/y_test.txt")
colnames(y_test) <- c("activity_id")

X_train <-read.table("/Users/apple/Desktop/UCI HAR Dataset/train/X_train.txt")
colnames(X_train) <- feature[,2]

y_train <- read.table("/Users/apple/Desktop/UCI HAR Dataset/train/y_train.txt")
colnames(y_train) <- c("activity_id")

#merge the training and the test sets to create one data set.
train_data <- cbind( X_train,y_train,subject_train)
test_data <- cbind(X_test,y_test,subject_test)
total_data <- rbind(train_data,test_data)

#bind the data
X <-rbind(X_train, X_test)
y <-rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

#get the useful data
pattern <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X_use <- X[, pattern]
names(X_use) <- gsub("\\(|\\)", "", features[pattern, 2])
names(X_use) <- tolower(names(X_use))

#remove the "_" in y and make it lowercase 
y[,1] = activity_labels[y[,1], 2]
names(y)<- "activity"
y <- gsub("_", "", tolower(as.character(y)))
finished_table <- cbind(subject, y, X_use)

#creat the new dataset and write it into file
finished_table <- -aggregate(. ~subject + activity, finished_table, mean)
write.table(finished_table, "/Users/apple/Desktop/UCI HAR Dataset/finished_data.txt")
