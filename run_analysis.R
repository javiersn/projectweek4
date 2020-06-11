library(dplyr)
library(tibble)
library(tidyr)
library(readr)
library(purrr)

# Reads source data if it hasn't been loaded yet
if (!exists("testdata") | !exists("traindata") | !exists("testsample")
    | !exists("trainsample")) {
  source("./load_data.R")
}

## BASIC TIDYING ##

# Reshape samples into a tidy stream of signals, removing overlap and reshaping
# samples into a single continuous column of signals.
testsignal <- tibble(SampleID = testsample$testbodyaccx$SampleID, 
                     Subject = testsample$testbodyaccx$Subject) 
testsignal <- full_join(testsignal, gather(select(testsample$testbodyaccx, 1:130), SignalNo, bodyaccx, -SampleID, -Subject), by=c("SampleID", "Subject"))
testsignal <- full_join(testsignal, gather(select(testsample$testbodyaccy, 1:130), SignalNo, bodyaccy, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo")) 
testsignal <- full_join(testsignal, gather(select(testsample$testbodyaccz, 1:130), SignalNo, bodyaccz, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo")) 
testsignal <- full_join(testsignal, gather(select(testsample$testbodygyrox, 1:130), SignalNo, bodygyrox, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo")) 
testsignal <- full_join(testsignal, gather(select(testsample$testbodygyroy, 1:130), SignalNo, bodygyroy, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo")) 
testsignal <- full_join(testsignal, gather(select(testsample$testbodygyroz, 1:130), SignalNo, bodygyroz, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo")) 
testsignal <- full_join(testsignal, gather(select(testsample$testtotalaccx, 1:130), SignalNo, totalaccx, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo")) 
testsignal <- full_join(testsignal, gather(select(testsample$testtotalaccx, 1:130), SignalNo, totalaccx, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo")) 
testsignal <- full_join(testsignal, gather(select(testsample$testtotalaccx, 1:130), SignalNo, totalaccx, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
testsignal <- testsignal %>% mutate(SignalNo = parse_number(SignalNo))

trainsignal <- tibble(SampleID = trainsample$trainbodyaccx$SampleID,
                     Subject = trainsample$trainbodyaccx$Subject)
trainsignal <- full_join(trainsignal, gather(select(trainsample$trainbodyaccx, 1:130), SignalNo, bodyaccx, -SampleID, -Subject), by=c("SampleID", "Subject"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$trainbodyaccy, 1:130), SignalNo, bodyaccy, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$trainbodyaccz, 1:130), SignalNo, bodyaccz, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$trainbodygyrox, 1:130), SignalNo, bodygyrox, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$trainbodygyroy, 1:130), SignalNo, bodygyroy, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$trainbodygyroz, 1:130), SignalNo, bodygyroz, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$traintotalaccx, 1:130), SignalNo, totalaccx, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$traintotalaccx, 1:130), SignalNo, totalaccx, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- full_join(trainsignal, gather(select(trainsample$traintotalaccx, 1:130), SignalNo, totalaccx, -SampleID, -Subject), by=c("SampleID", "Subject", "SignalNo"))
trainsignal <- trainsignal %>% mutate(SignalNo = parse_number(SignalNo))

## SOLVE THE PROJECTS GOALS ##
# 1a. Merge the training and the test data sets to create one data set, with an
# added column to identify test and train data.
featuredata <- bind_rows(
  testdata %>% mutate(Set = "Test"),
  traindata %>% mutate(Set = "Train")
)
# 1b. Merge the signal streams with an added column to identify test and train
signals <- bind_rows(
  testsignal %>% mutate(Set = "Test"),
  trainsignal %>% mutate(Set = "Train")
)

# 2. Extract only the measurements on the mean and standard deviation for each 
# measurement.
signal_summary <- tibble(
  means=map_dbl(select(signals, -SampleID, -Subject, -SignalNo, -Set), mean, na.rm=TRUE),
  sd=map_dbl(select(signals, -SampleID, -Subject, -SignalNo, -Set), sd, na.rm=TRUE)
)
data_summary <- tibble(
  means=map_dbl(select(featuredata, -SampleID, -Subject, -Activity, -Set), mean, na.rm=TRUE),
  sd=map_dbl(select(featuredata, -SampleID, -Subject, -Activity, -Set), sd, na.rm=TRUE)
)

# 3. Uses descriptive activity names to name the activities in the data set
featuredata$Activity <- activitylabels[featuredata$Activity]

# 4. Appropriately labels the data set with descriptive variable names.
# Answer. Data columns were named as their respective features, signal columns 
# were named as the respective signal.

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_x_activity <- featuredata %>% 
  select(-SampleID, -Set) %>% 
  group_by(Activity, Subject) %>% 
  summarise_all(mean)
