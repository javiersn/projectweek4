# Week 4 Project

## Description
The project's goal is to read, load, tidy and analyze data collected from gyroscopes and accelerometers in smartphones, and labeled for specific types of activities.

The process is divided into two stages coded in two separate R scripts. The file *load_data.R* reads the downloaded files and loads them into R objetcs. The file *run_analysis.R* perfors all tidy transformations and analysis operations.

## Requirements
The scripts require these libraries: *tibble* and *dplyr*.

## Source Data
All source data was obtained from: [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

A data set description is available at: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

All source data files have been saved into this repository within `./data/` directory.

## Scripts
### load_data.R
The scripts goal is to provide R objects containing all the source data without any alteration to the source data other than combining it to reduce the number of objects, adding columns names for readability and adding an ID for referential integrity. The scripts final result provides 4 R tibble objects which include all the unaltered source data:

* `testdata` - tibble with the combined data from `subject_test.txt`, `X_test.txt` and `y_test.txt`, and an added SampleID column.
* `testsignal` - list of tibbles with the data from each file within the `test/Inertial Signals/` directory, each tibble with added SampleID and Subject data.
* `traindata` - tibble with the combined data from `subject_train.txt`, `X_train.txt` and `y_train.txt`, and an added SampleID column.
* `trainsignal` - list of tibbles with the data from each file within the `train/Inertial Signals/` directory, each tibble with added SampleID and Subject data.

The script also provides 2 catalogues in form of R vectors for reference:

* `featurenames` - the source catalogue provided in _features.txt_.
* `activitylabels` - the source catalogue provided in _activity_labels.txt_.

### run_analysis.R
This file takes the two vectors and four tibbles created by `load_data.R` and performs reshaping, tidying and analysis operations to provide the following tidy and summary tibbles:

- `featuredata` tidy table of feature observations, including test and train experiments.
- `signal` tidy table including all signal observations.
- `data_summary` averages and standard deviations for `featuredata`.
- `signal_summary` averages and standard deviations for `signal` data.
- `data_x_activity` averages for `featuredata` per subject and activity.

