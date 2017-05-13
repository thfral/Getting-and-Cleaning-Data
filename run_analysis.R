# Download the file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Dataset.zip")

# Unzip
unzip("Dataset.zip", overwrite = TRUE) 

# Load features
features <- read.table("UCI HAR Dataset/features.txt")
names(features) <- c("id","description")

# Load the datasets
# Train
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")[grep(".*mean.*|.*std.*", features$description)]
names(train_x) <- features[grep(".*mean.*|.*std.*", features$description),2]

train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
names(train_y) <- "Activities"


train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(train_subject) <- "Subjects"

train_total <- cbind(train_subject, train_y, train_x)

# Test
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")[grep(".*mean.*|.*std.*", features$description)]
names(test_x) <- features[grep(".*mean.*|.*std.*", features$description),2]

test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
names(test_y) <- "Activities"

test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(test_subjects) <- "Subjects"

test_total <- cbind(test_subjects, test_y, test_x)

# Total
total <- rbind(test_total, train_total)

# Load activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("id","description")

# Ajust activities names
total$Activities <- factor(total$Activities, levels = activity_labels$id, labels = activity_labels$description)

# Summarise dataset with the mean
library(reshape2)

total_melt <- melt(total, id = c("Subjects", "Activities"))
total_mean <- dcast(total_melt, Subjects + Activities ~ variable, mean)

# Write the final file
write.table(total_mean, "tidy.txt", row.names = FALSE, quote = FALSE)