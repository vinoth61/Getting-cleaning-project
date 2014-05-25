## Load the packages reshape and gdata
library (reshape)
library (gdata)
## Merges the training and the test sets to create one data set
setwd ("./UCI HAR Dataset")
train<- read.table("train/X_train.txt",header=FALSE)
test <- read.table("test/X_test.txt",header=FALSE)
file1 <- rbind(train,test)
## similarly for subject_test and subject_train
train <- read.table ("train/subject_train.txt",header=FALSE)
test <- read.table ("test/subject_test.txt",header = FALSE)
file2 <- rbind (train,test)
## merging y_train and y_test
train <- read.table ("train/y_train.txt", header = FALSE)
test <- read.table ("test/y_test.txt", header = FALSE)
file3 <- rbind (train,test)
## activity label text
act <- read.table ("activity_labels.txt")
feature <- read.table ("features.txt")
## Extracts only the measurements on the mean and standard deviation 
## for each measurement
id <- grep("-mean\\(\\)|-std\\(\\)", feature[, 2])
## subset only these values
file1 <- file1[, id]
names(file1) <- feature[id, 2]
## Uses descriptive activity names to name the activities in the data set
file3[,1] <- act[file3[,1], 2]
## 4. Appropriately labels the data set with descriptive activity names.
names(file2) <- "subjects"
names(file3) <- "activities"

## merging all data into one, this is full merged dataset
combdata <- cbind(file1, file2, file3)

## 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
numCols = dim(combdata)[2]
nactivities = length(act[,1])
nsubjects = length(unique(file2)[,1])

## Find number of unique subject
uSubjects = unique(file2)[,1]

## Melt to create a second final tidy dataset 
md <- melt(combdata, id.vars=c("activities","subjects"))
meanData <- dcast(md,subjects + activities ~ variable,mean)
setwd("..")
write.table(meanData, "tidy.txt", sep="\t")

## End of the run_analysis