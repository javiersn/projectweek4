# Code Book
## Source and Credit
All information was obtained from **UCI Center for Machine Learning and Intelligent Systems**. Description and downloads are available at [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Experiment Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.

## Source Data Description
For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

## Reading the Source Data
In order to preserve the source data properties, all files are read with minumum transformations:

- `activity_labels.txt` is read as csv, and stored as a vector for future reference.
- `subject_test.txt`, `X_test.txt` and `y_test.txt` are read as fixed width files, and combined into a single tibble for ease of access, with an added SampleID column to provide a link to other data. The combined data is published as the tibble named `testdata`, which contains the following variables:
  - _SampleID_: A integer identifying a sampel, provided as a link between features and signal samples.
  - _Subject_: The integer identifier of the subject in the experiments.
  - _Activity_: The numeric identifier of the activity manually assigned to the sample during the experiment.
  - 561 numeric variables corresponding to the 561 features documentede in the `features.txt` file.
- `subject_train.txt`, `X_train.txt` and `y_train.txt` are read as fixed width files, and combined into a single tibble for ease of access, with an added SampleID column to provide a link to other data. The combined data is published as the tibble named `traindata`, which contains the following variables:
  - _SampleID_: A integer identifying a sampel, provided as a link between features and signal samples.
  - _Subject_: The integer identifier of the subject in the experiments.
  - _Activity_: The activity label which was manually assigned to the sample during the experiment.
  - 561 numeric variables corresponding to the 561 features documentede in the `features.txt` file, the unit for all observations is G force factor.
- All 18 files within `Innertial Signals` directory are read as fixed width files, combined with subject data, and numbered by SampleID to provide a link to the previously described data. They are grouped into two lists of tibbles: `testsample` and `trainsample` where each tibble contains all samples of a single variable. Each of the 18 sample data tibbles include a row per sample and:
  - _SampleID_: A integer identifying a sampel, provided as a link between features and signal samples.
  - _Subject_: The integer identifier of the subject in the experiments.
  - 256 variables which represent the 256 observations in each sample, the unit for all observations is G force factor.

## Final Data Sets
`testsample` and `trainsample` lists data is merged and simplified into a two tibbles `testsignal` and `trainsignal` respectively, which eliminates overlapping and reshapes the dataset to include:

  - _SampleID_: A integer identifying a sampel, provided as a link between features and signal samples.
  - _Subject_: The integer identifier of the subject in the experiments.
  - _SignalNo_: The integer identifier of each signal within each sample.
  - _bodyaccx_: The x axis acceleration recorded in G force factor as unit, after substracting gravity.
  - _bodyaccy_: The y axis acceleration recorded in G force factor as unit, after substracting gravity.
  - _bodyaccz_: The z axis acceleration recorded in G force factor as unit, after substracting gravity.
  - _bodygyrox_: The x axis angular velocity recorded in radians/second as unit.
  - _bodygyroy_: The y axis angular velocity recorded in radians/second as unit.
  - _bodygyroz_: The z axis angular velocity recorded in radians/second as unit.
  - _totalaccx.x_: The x axis acceleration recorded in G force factor as unit, including gravity.
  - _totalaccx.y_: The y axis acceleration recorded in G force factor as unit, including gravity.
  - _totalaccx.z_: The z axis acceleration recorded in G force factor as unit, including gravity.

## Summary Data
`featuredata` tibble merges `testdata` and `traindata` into a single tibble by adding:

- `Set` specifies "test" or "train" to indicate the type of observation.

`signal` tibble merges `testsignal` and `trainsignal` into a single tibble by adding:

- `Set` specifies "test" or "train" to indicate the type of observation.

`data_summary` details the mean and standard deviation from each calculated feature. Each row is a sample observation, and columns are:

- `mean`: the average for all recordings of the feature.
- `sd`: the standard deviation for all recordings of the feature. 

`signal_summary` details the mean and standard deviation from each type of signal. Each row is a type of signal, and columns are:

- `mean`: the average for all recordings of the type of signal.
- `sd`: the standard deviation for all recordings of the type of signal. 

`data_x_activity` details the mean and standard deviation from each calculated feature per activity and per subject. Each row is a unique combination of `Activity` and `Subject` and columns are:

- 561 columns for all the features described in `features.txt`, each containing the average for each activity and subject combination.

## License
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.