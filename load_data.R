library(tibble)
library(dplyr)

## PRE-LOAD SOME CATALOGUES
# Load the names of the features and activity labels as vectors
featurenames <- read.csv("./data/features.txt", header=FALSE, sep = " ", 
                     row.names=1)[, 1]
activitylabels <- read.csv("./data/activity_labels.txt", header=FALSE, sep=" ", 
                     row.names=1)[, 1]

## LOAD SOURCE DATA
# Load the subjects' IDs
testsubjects <- read.csv("./data/test/subject_test.txt", header=FALSE, 
                         col.names="Subject") %>% as_tibble()
trainsubjects <- read.csv("./data/train/subject_train.txt", header=FALSE, 
                          col.names="Subject") %>% as_tibble()

# Load the features' data: 561 columns of 16 characters each, and use the 
# names from features.txt as column names
testx <- read.fwf("./data/test/X_test.txt", rep(16, 561), header=FALSE, 
                  col.names=featurenames) %>% as_tibble()
trainx <- read.fwf("./data/train/X_train.txt", rep(16, 561), header=FALSE, 
                   col.names=featurenames) %>% as_tibble()

# Load the activity data
testy <- read.csv("./data/test/y_test.txt", header=FALSE, 
                  col.names="Activity") %>% as_tibble()
trainy <- read.csv("./data/train/y_train.txt", header=FALSE, 
                   col.names="Activity") %>% as_tibble()

# Gather feature data into a tibble for test and train feature sets, including
# subject, activity and an added SampleID to identify each observation.
testdata <- bind_cols(testsubjects,
                      testy,
                      testx) %>% rowid_to_column(var="SampleID")

traindata <- bind_cols(trainsubjects,
                       trainy,
                       trainx) %>% rowid_to_column(var="SampleID")

# Load sample data into a list of tibbles, as they are in the files. Each file
# files has 256 columns with 16 characters each. For referential integrity we 
# added columns with sample id and subject id.
w <- rep(16, 256)
testsample <- list()
testsample$testbodyaccx <- read.fwf("./data/test/Inertial Signals/body_acc_x_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testbodyaccy <- read.fwf("./data/test/Inertial Signals/body_acc_y_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testbodyaccz <- read.fwf("./data/test/Inertial Signals/body_acc_z_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testbodygyrox <- read.fwf("./data/test/Inertial Signals/body_gyro_x_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testbodygyroy <- read.fwf("./data/test/Inertial Signals/body_gyro_y_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testbodygyroz <- read.fwf("./data/test/Inertial Signals/body_gyro_z_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testtotalaccx <- read.fwf("./data/test/Inertial Signals/total_acc_x_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testtotalaccy <- read.fwf("./data/test/Inertial Signals/total_acc_y_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
testsample$testtotalaccz <- read.fwf("./data/test/Inertial Signals/body_acc_z_test.txt",
                         w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(testsubjects, .after=1)
trainsample <- list()
trainsample$trainbodyaccx <- read.fwf("./data/train/Inertial Signals/body_acc_x_train.txt",
                          w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$trainbodyaccy <- read.fwf("./data/train/Inertial Signals/body_acc_y_train.txt",
                          w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$trainbodyaccz <- read.fwf("./data/train/Inertial Signals/body_acc_z_train.txt",
                          w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$trainbodygyrox <- read.fwf("./data/train/Inertial Signals/body_gyro_x_train.txt",
                           w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$trainbodygyroy <- read.fwf("./data/train/Inertial Signals/body_gyro_y_train.txt",
                           w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$trainbodygyroz <- read.fwf("./data/train/Inertial Signals/body_gyro_z_train.txt",
                           w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$traintotalaccx <- read.fwf("./data/train/Inertial Signals/total_acc_x_train.txt",
                           w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$traintotalaccy <- read.fwf("./data/train/Inertial Signals/total_acc_y_train.txt",
                           w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)
trainsample$traintotalaccz <- read.fwf("./data/train/Inertial Signals/body_acc_z_train.txt",
                           w, header=FALSE) %>% as_tibble() %>%
  rowid_to_column(var="SampleID") %>% add_column(trainsubjects, .after=1)

# Remove temporary work objects
rm("featurenames", "testsubjects", "trainsubjects", "testx", "testy", "trainx",
   "trainy", "w")