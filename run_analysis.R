download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "data.zip")

##Reads in activity labels, and data names
activityL <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActNum","ActLabel"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "DataPoints"))

##Reads in test data. Col names of x test will be pulled from features data.
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject") 
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$DataPoints)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "ActNum")

##reads in train data. 
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$DataPoints)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "ActNum")

##Binds the data together, 
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subj <- rbind(subject_train, subject_test)
data <- cbind(subj, y, x)

##Changes the activity from their codes 1-6 to their activity, standing/sitting etc.
data$ActNum <- gsub("1", activityL[1,2], data$ActNum)
data$ActNum <- gsub("2", activityL[2,2], data$ActNum)
data$ActNum <- gsub("3", activityL[3,2], data$ActNum)
data$ActNum <- gsub("4", activityL[4,2], data$ActNum)
data$ActNum <- gsub("5", activityL[5,2], data$ActNum)
data$ActNum <- gsub("6", activityL[6,2], data$ActNum)

##meanstd gets the columns that have the words mean and std.
##extracteddata is a new table that just pulls subj, activity and columns with mean and std.
meanstd <- grep("mean|std", names(data))
extracteddata <- data[,c(1,2,meanstd)]
write.table(extracteddata, "extracteddata.txt", row.name=FALSE)

##averages by subject and actnum. 
##orders them
averageddata <- aggregate(extracteddata[,3:81], by = list(extracteddata$subject, extracteddata$ActNum), FUN = mean)
averageddata <- averageddata[order(averageddata$Group.1, averageddata$Group.2),]
write.table(averageddata, "averagedata.txt", row.name=FALSE)

