# packages needed
install.packages("dplyr")
library(dplyr)
install.packages("downloader")
library(downloader)

# download and unzip
file.create("data.zip")
zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(zipurl, dest="data.zip", mode="wb") 
unzip ("data.zip", exdir = "./")

# read data
wd <- getwd()
mainpath <- file.path(wd, "UCI HAR Dataset")
trainpath <- file.path(mainpath, "train")
testpath <- file.path(mainpath, "test")
setwd(testpath)
test <- tbl_df(read.table("X_test.txt"))
testact <- tbl_df(read.table("y_test.txt"))
testsubj <- tbl_df(read.table("subject_test.txt"))
setwd(trainpath)
train <- tbl_df(read.table("X_train.txt"))
trainact <- tbl_df(read.table("y_train.txt"))
trainsubj <- tbl_df(read.table("subject_train.txt"))

# bind train and test and give column names
setwd(mainpath)
subjects <- rbind(trainsubj, testsubj)
acts <- rbind(trainact, testact)
varnames <- read.table("features.txt")
varnames <- as.character(varnames$V2)
df <- rbind(train, test)
colnames(df) <- varnames

# select mean()-variables
meanstd <- grep("mean\\(\\)|std\\(\\)", names(df))
df <- df[,meanstd]

# rename activities
df <- tbl_df(cbind(acts,df))
df <- rename(df, "activity" = V1)
df$activity[df$activity==1] <- "WALKING"
df$activity[df$activity==2] <- "WALKING_UPSTAIRS"
df$activity[df$activity==3] <- "WALKING_DOWNSTAIRS"
df$activity[df$activity==4] <- "SITTING"
df$activity[df$activity==5] <- "STANDING"
df$activity[df$activity==6] <- "LAYING"

# add subjects names
df <- tbl_df(cbind(subjects, df))
df <- rename(df, "subjects" = V1)

# group by subject and activity and compute variables' means
dfby <- group_by(df, subjects, activity) %>% summarize_all(mean)

# display result and create txt files
df
dfby
View(df)
View(dfby)

setwd(wd)
pathdf <- file.path(wd, "df.txt")
pathdfby <- file.path(wd, "dfby.txt")
write.table(df, pathdf, row.names=FALSE)
write.table(dfby, pathdfby, row.names=FALSE)

file.remove("data.zip")
unlink("UCI HAR Dataset", recursive = TRUE)
# detach("package:downloader", unload=TRUE)
# detach("package:dplyr", unload=TRUE)
# remove.packages("downloader")
# remove.packages("dplyr")

