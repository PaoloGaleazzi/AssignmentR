# The script run_analysis.R does the following:
# - installs the packages dplyr and downloader
# - downloads the file in the working directory and unzips it  
# - creates a unique data frame, named df, by binding together the two data frames with the training set and the test set
# - gives descriptive column names to df
# - selects only the mean()-variables/columns in df
# - associates each observation in df with the corresponding subject and activity as specified by the files subject.train.txt, subject_test.txt, y_train.txt and y_test.txt 
# - groups df by subject and activity in a second data frame called dfby and computes the variables' mean values wrt the resulting groups
# - finally, displays df and dfby in the console and saves them as .csv files in the working directory
