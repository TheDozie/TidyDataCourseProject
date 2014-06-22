==================================================================
CodeBook for Getting and Cleaning Data Course Project
==================================================================

=============================================
The supplied data sets
=============================================


------------------------------------
File: activity_labels.txt
------------------------------------
This file provides the lookup table for the activity numbers used to identify the activities in the main data files.

Variables:

> **activityNo**

>> activity number

>> integer

>> 1 .. 6

> **activitydescr**

>> activity description corresponding to the activity numbers as follows:

>>> 1: WALKING

>>> 2: WALKING_UPSTAIRS

>>> 3: WALKING_DOWNSTAIRS

>>> 4: SITTING

>>> 5: STANDING

>>> 6: LAYING


------------------------------------
File: features.txt
------------------------------------
List of the features in the tidy dataset, in the same column order to enable direct use in setting column names when x_test and x_train are read.

Variables:

> **featureNo**

>> serial number of features in column order, i.e., corresponding the to features column location in the tidy data frame

>> integer

>> 1 .. 66

> **featureDescr**

>> the descriptive name of the feature = column names for the data frame

>> character string

>> variable length

The description accompanying the datasets (in file features_info.txt) is as follows:

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

> Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

> Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

> These signals were used to estimate variables of the feature vector for each pattern:  

>> '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.


>> tBodyAcc-XYZ

>> tGravityAcc-XYZ

>> tBodyAccJerk-XYZ

>> tBodyGyro-XYZ

>> tBodyGyroJerk-XYZ

>> tBodyAccMag

>> tGravityAccMag

>> tBodyAccJerkMag

>> tBodyGyroMag

>> tBodyGyroJerkMag

>> fBodyAcc-XYZ

>> fBodyAccJerk-XYZ

>> fBodyGyro-XYZ

>> fBodyAccMag

>> fBodyAccJerkMag

>> fBodyGyroMag

>> fBodyGyroJerkMag

> The set of variables that were estimated from these signals are: 

>> mean(): Mean value

>> std(): Standard deviation

>> mad(): Median absolute deviation 

>> max(): Largest value in array

>> min(): Smallest value in array

>> sma(): Signal magnitude area

>> energy(): Energy measure. Sum of the squares divided by the number of values. 

>> iqr(): Interquartile range 

>> entropy(): Signal entropy

>> arCoeff(): Autorregresion coefficients with Burg order equal to 4

>> correlation(): correlation coefficient between two signals

>> maxInds(): index of the frequency component with largest magnitude

>> meanFreq(): Weighted average of the frequency components to obtain a mean frequency

>> skewness(): skewness of the frequency domain signal 

>> kurtosis(): kurtosis of the frequency domain signal 

>> bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.

>> angle(): Angle between to vectors.

> Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

>> gravityMean

>> tBodyAccMean

>> tBodyAccJerkMean

>> tBodyGyroMean

>> tBodyGyroJerkMean

> The complete list of variables of each feature vector is available in 'features.txt'


------------------------------------------------
File: x_train.txt
------------------------------------------------
The training dataset containing readings that correspond to the variables in features.txt, in the same order. This enables reading the content of features.txt into the column names of the dataset.

------------------------------------------------
File: x_test.txt
------------------------------------------------
The test dataset containing readings that correspond to the variables in features.txt, in the same order. 


------------------------------------
File: y_test.txt
------------------------------------
This file contains the activity numbers corresponding to the records in x_test.txt, in the same row order. That is, row 1 in this file corresponds to row 1 in x_test.txt, and so on.  The corresponding activity labels are the same as the activity_labels.txt file.

> **acticityNo**

>> activity number for identifying the activities

>> integer

>> 1 .. 6

This file therefore needed to be read in and appended column-wise with the dataset in x_train.txt to match the activities that each row in the dataset refers to. Use the `cbind()` function to join them. 

To get the descriptive names of the activities, this file needs to be merged with the activity_labels, and then with the observations. However, using the `merge()` function after appending the files would put the activity labels at the end of a very wide data frame, making them difficult to work with. On the other hand, merging to the y_train before merging to the dataset would re-order the result and would no longer correspond to the activities they relate to. The order should also be retained to correspond to the record order in the subjects file. 


The files were therefore joined as follows:

```r
ytest<-transform(ytest,activityDescr=activities[activityNo,2])
full_test<-cbind(subject_test,cbind(activity=ytest$activityDescr,xtest))
```

------------------------------------
File: y_train.txt
------------------------------------
This file contains the activity numbers corresponding to the records in x_train.txt, in the same row order. T

See description of y_test.txt above.

----------------------------------------
File: subject_test.txt
----------------------------------------
Each row in this file identifies the identifies the subject that performed the corresponding row activity in x_test.txt. Therefore in manipulating the files, care should be taken to preserve the row order in this file, y_test.txt and x_test.txt. See description of y_test.txt for how the files were joined.

----------------------------------------
File: subject_train.txt
----------------------------------------
Each row in this file identifies the identifies the subject that performed the corresponding row activity in x_rain.txt. Therefore in manipulating the files, care should be taken to preserve the row order in this file, y_train.txt and x_train.txt.


============================================
The tidy dataset produced are the following:
============================================

-----------------------------------------------------
File: x_tidy.txt
-----------------------------------------------------
This is the main output of the analysis. The observations in x_test.txt and x_train.txt were merged with the corresponding subjects and activity labels then appended with `rbind()`. Then only columns for mean and standard deviation readings were retained. These are features in the original file whose names contain the strings "mean()" and "st"()". Use `grep()` to extract the indices of the required variables into a vector, 'tokeep'. Then use tokeep to extract the required columns:


```r
features<-read.table("features.txt")
names(features)<- c("featureNo","featureDescr")
tokeep<-c(grep("mean()", features$featureDescr, fixed=TRUE), 
          grep("std()",features$featureDescr, fixed=TRUE))
tokeep<-sort(tokeep)
xtest<-xtest[,tokeep]
```

We want the variables to have meaningful names. So we rename the variable descriptions to be more meaning:

- "Acc" = "_accelerometer"

- "Gyro" = "_gyroscope"

- "tBody" = "time_body" for time domain body measurements

- "tGravity" = "time_gravity" for time-domain gravity measurements

- "fBody" = "frequency_body" for frequency domain body measurements

- "fGravity" = "frequency_gravity" for frequency-domain gravity measurements

- "mean()" = "mean"

- "std()" =  "stdDev"


```r
## transform the descriptions to be more meaningful
features<-transform(features, featureDescr = sub("Acc", "-accelerometer", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("Gyro", "-gyroscope", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("mean()", "mean", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("std()", "stdDev", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("tBody", "time-body", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("fBody", "frequency-body", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("tGravity", "time-gravity", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = sub("fGravity", "frequency-gravity", featureDescr, fixed=TRUE))
features<-transform(features, featureDescr = gsub("-", "_", featureDescr, fixed=TRUE))
```

The variables are written in fixed with format, without quote so that it will be easy to import into a data frame.

The resulting variables are:

time_body_accelerometer_mean_X        15

> The mean of the body (vs. gravity) linear acceleration component of time domain signals in the X direction

>> real number

time_body_accelerometer_mean_Y        15

> The mean of the body (vs. gravity) linear acceleration component of time domain signals in the Y direction

>> real number

time_body_accelerometer_mean_Z        15

> The mean of the body (vs. gravity) linear acceleration component of time domain signals in the Z direction

>> real number

time_body_accelerometer_stdDev_X        15

> The standard deviation of the body (vs. gravity) linear acceleration component of time domain signals in the X direction

>> real number

time_body_accelerometer_stdDev_Y        15

> The standard deviation of the body (vs. gravity) linear acceleration component of time domain signals in the Y direction

>> real number

time_body_accelerometer_stdDev_Z        15

> The standard deviation of the body (vs. gravity) linear acceleration component of time domain signals in the Z direction

>> real number

time_gravity_accelerometer_mean_X

> The mean of the gravity (vs. body) linear acceleration component of time domain signals in the X direction

>> real number

time_gravity_accelerometer_mean_Y

> The mean of the gravity (vs. body) linear acceleration component of time domain signals in the Y direction

>> real number

time_gravity_accelerometer_mean_Z

> The mean of the gravity (vs. body) linear acceleration component of time domain signals in the Z direction

>> real number

time_gravity_accelerometer_stdDev_X

> The standard deviation of the gravity (vs. body) linear acceleration component of time domain signals in the X direction

>> real number

time_gravity_accelerometer_stdDev_Y

> The standard deviation of the gravity (vs. body) linear acceleration component of time domain signals in the Z direction

>> real number

time_gravity_accelerometer_stdDev_Z

> The standard deviation of the gravity (vs. body) linear acceleration component of time domain signals in the Z direction

>> real number

time_body_accelerometerJerk_mean_X

> mean of the jerk signal derived from the body acceleration (linear) in the X direction

>> real number

time_body_accelerometerJerk_mean_Y

> Mean of the jerk signal derived from the body acceleration (linear) in the Y direction

>> real number

time_body_accelerometerJerk_mean_Z

> Mean of the jerk signal derived from the body acceleration (linear) in the Z direction

>> real number

time_body_accelerometerJerk_stdDev_X

> Standard deviation of the jerk signal derived from the body acceleration (linear) in the X direction

>> real number

time_body_accelerometerJerk_stdDev_Y

> Standard deviation of the jerk signal derived from the body acceleration (linear) in the Y direction

>> real number

time_body_accelerometerJerk_stdDev_Z

> Standard deviation of the jerk signal derived from the body acceleration (linear) in the Z direction

>> real number

time_body_gyroscope_mean_X

> The mean of the body angular acceleration component (from the gyroscope) of time domain signals in the X direction

>> real number

time_body_gyroscope_mean_Y

> The mean of the body angular acceleration component (from the gyroscope) of time domain signals in the Y direction

>> real number

time_body_gyroscope_mean_Z

> The mean of the body angular acceleration component (from the gyroscope) of time domain signals in the Z direction

>> real number

time_body_gyroscope_stdDev_X

> The standard deviation of the body angular acceleration component (from the gyroscope) of time domain signals in the X direction

>> real number

time_body_gyroscope_stdDev_Y

> The standard deviation of the body angular acceleration component (from the gyroscope) of time domain signals in the Y direction

>> real number

time_body_gyroscope_stdDev_Z

> The standard deviation of the body angular acceleration component (from the gyroscope) of time domain signals in the Z direction

>> real number

time_body_gyroscopeJerk_mean_X

> mean of the jerk signal derived from the body acceleration (angular) in the X direction

>> real number

time_body_gyroscopeJerk_mean_Y

> mean of the jerk signal derived from the body acceleration (angular) in the Y direction

>> real number

time_body_gyroscopeJerk_mean_Z

> mean of the jerk signal derived from the body acceleration (angular) in the Z direction

>> real number

time_body_gyroscopeJerk_stdDev_X

> standard deviation of the jerk signal derived from the body acceleration (angular) in the X direction

>> real number

time_body_gyroscopeJerk_stdDev_Y

> standard deviation of the jerk signal derived from the body acceleration (angular) in the Y direction

>> real number

time_body_gyroscopeJerk_stdDev_Z

> standard deviation of the jerk signal derived from the body acceleration (angular) in the Z direction

>> real number

time_body_accelerometerMag_mean

> Mean of the magnitude of the body component of the time domain linear acceleration signal calculated with Euclidean norm

>> real number

time_body_accelerometerMag_stdDev

> Standard deviation of the magnitude of the body component of the time domain linear acceleration signal calculated with Euclidean norm

>> real number

time_gravity_accelerometerMag_mean

> Mean of the magnitude of the gravity component of the time domain linear acceleration signal calculated with Euclidean norm

>> real number

time_gravity_accelerometerMag_stdDev

> Standard deviation of the magnitude of the gravity component of the time domain linear acceleration signal calculated with Euclidean norm

>> real number

time_body_accelerometerJerkMag_mean

> Mean of the magnitude of the body component of the time domain linear acceleration jerk signal calculated with Euclidean norm

>> real number

time_body_accelerometerJerkMag_stdDev

> Standard deviation of the magnitude of the body component of the time domain linear acceleration jerk signal calculated with Euclidean norm

>> real number

time_body_gyroscopeMag_mean

> Mean of the magnitude of the body component of the time domain angular acceleration signal calculated with Euclidean norm

>> real number

time_body_gyroscopeMag_stdDev

> Standard deviation of the magnitude of the body component of the time domain angular acceleration signal calculated with Euclidean norm

>> real number

time_body_gyroscopeJerkMag_mean

> Mean of the magnitude of the body component of the time domain angular acceleration jerk signal calculated with Euclidean norm

>> real number

time_body_gyroscopeJerkMag_stdDev

> Standard deviation of the magnitude of the body component of the time domain angular acceleration jerk signal calculated with Euclidean norm

>> real number

frequency_body_accelerometer_mean_X        15

> The mean of the body (vs. gravity) linear acceleration component of frequency domain signals in the X direction

>> real number

frequency_body_accelerometer_mean_Y        15

> The mean of the body (vs. gravity) linear acceleration component of frequency domain signals in the Y direction

>> real number

frequency_body_accelerometer_mean_Z        15

> The mean of the body (vs. gravity) linear acceleration component of frequency domain signals in the Z direction

>> real number

frequency_body_accelerometer_stdDev_X        15

> The standard deviation of the body (vs. gravity) linear acceleration component of frequency domain signals in the X direction

>> real number

frequency_body_accelerometer_stdDev_Y        15

> The standard deviation of the body (vs. gravity) linear acceleration component of frequency domain signals in the Y direction

>> real number

frequency_body_accelerometer_stdDev_Z        15

> The standard deviation of the body (vs. gravity) linear acceleration component of frequency domain signals in the Z direction

>> real number

frequency_body_accelerometerJerk_mean_X

> mean of the jerk of signal in the frequency domain derived from the body acceleration (linear) in the X direction

>> real number

frequency_body_accelerometerJerk_mean_Y

> Mean of the jerk signal in the frequency domain derived from the body acceleration (linear) in the Y direction

>> real number

frequency_body_accelerometerJerk_mean_Z

> Mean of the jerk signal in the frequency domain derived from the body acceleration (linear) in the Z direction

>> real number

frequency_body_accelerometerJerk_stdDev_X

> Standard deviation of the jerk signal in the frequency domain derived from the body acceleration (linear) in the X direction

>> real number

frequency_body_accelerometerJerk_stdDev_Y

> Standard deviation of the jerk signal in the frequency domain derived from the body acceleration (linear) in the Y direction

>> real number

frequency_body_accelerometerJerk_stdDev_Z

> Standard deviation of the jerk signal in the frequency domain derived from the body acceleration (linear) in the Z direction

>> real number

frequency_body_gyroscope_mean_X

> The mean of the body angular acceleration component (from the gyroscope) of frequency domain signals in the X direction

>> real number

frequency_body_gyroscope_mean_Y

> The mean of the body angular acceleration component (from the gyroscope) of frequency domain signals in the Y direction

>> real number

frequency_body_gyroscope_mean_Z

> The mean of the body angular acceleration component (from the gyroscope) of frequency domain signals in the Z direction

>> real number

frequency_body_gyroscope_stdDev_X

> The standard deviation of the body angular acceleration component (from the gyroscope) of frequency domain signals in the X direction

>> real number

frequency_body_gyroscope_stdDev_Y

> The standard deviation of the body angular acceleration component (from the gyroscope) of frequency domain signals in the Y direction

>> real number

frequency_body_gyroscope_stdDev_Z

> The standard deviation of the body angular acceleration component (from the gyroscope) of frequency domain signals in the Z direction

>> real number

frequency_body_accelerometerMag_mean

> Mean of the magnitude of the body component of the frequency domain linear acceleration signal calculated with Euclidean norm

>> real number

frequency_body_accelerometerMag_stdDev

> Standard deviation of the magnitude of the body component of the frequency domain linear acceleration signal calculated with Euclidean norm

>> real number

frequency_body_accelerometerJerkMag_mean

> Mean of the magnitude of the body component of the frequency domain linear acceleration jerk signal calculated with Euclidean norm

>> real number

frequency_body_accelerometerJerkMag_stdDev

> Standard deviation of the magnitude of the body component of the frequency domain linear acceleration jerk signal calculated with Euclidean norm

>> real number

frequency_body_gyroscopeMag_mean

> Mean of the magnitude of the body component of the frequency domain angular acceleration signal calculated with Euclidean norm

>> real number

frequency_body_gyroscopeMag_stdDev

> Standard deviation of the magnitude of the body component of the frequency domain angular acceleration signal calculated with Euclidean norm

>> real number

frequency_body_gyroscopeJerkMag_mean

> Mean of the magnitude of the body component of the frequency domain angular acceleration jerk signal calculated with Euclidean norm

>> real number

frequency_body_gyroscopeJerkMag_stdDev

> Standard deviation of the magnitude of the body component of the frequency domain angular acceleration jerk signal calculated with Euclidean norm

>> real number

------------------------------------
File: y_tidy.txt
------------------------------------
This file contains the activity numbers corresponding to the records in x_tidy.txt, in the same row order. That is, row 1 in this file corresponds to row 1 in x_tidy.txt, and so on.  The corresponding activity labels are the same as the supplied activity_labels.txt file.

> acticityNo

>> activity number for identifying the activities

>> integer

>> 1 .. 6

------------------------------------
File: x_mean.txt
------------------------------------
This file contains the mean of the the variables for each activity.

Variables:

> Same as x_tidy.txt.

Use the `melt()` and `dcast()` functions from the **reshape2** package:

```r
library(reshape2)
tidy_names<-names(tidy_data) ## extract the variable names
tidy_id<-tidy_names[1] ## the activity labels against which the means are required are in column 1
tidy_vars<-tidy_names[-1] ## remove column 1 to get the variables
tidy_melt<-melt(tidy_data,measure.vars=tidy_vars,id=tidy_id)
tidy_mean<-dcast(tidy_melt, activity ~ variable, mean)
```

------------------------------------
File: y_mean.txt
------------------------------------
Activity numbers corresponding to the x_mean.txt, similar to y_tidy and x_tidy. 

Variables:

> Same as y_tidy.txt.

------------------------------------
File: activity_labels.txt
------------------------------------
This is the activity_labels file, unchanged as supplied.

Variables:

> **activityNo**

>> activity number

>> integer

>> 1 .. 6

> **activitydescr**

>> activity description corresponding to the activity numbers as follows:

>>>1: WALKING

>>>2: WALKING_UPSTAIRS

>>>3: WALKING_DOWNSTAIRS

>>>4: SITTING

>>>5: STANDING

>>>6: LAYING

------------------------------------
File: subject_tidy.txt
------------------------------------
Like the supplied subject_test.txt and subject_train.txt, each row of this file identifies the subject who performed the activity for corresponding rows in the x_tidy.txt file.

Variable:

> **subjectNo**

>> subject number for identifying the subjects

>> integer

>> 1 .. 30

------------------------------------
File: tidy_features.txt
------------------------------------
List of the features in the tidy dataset, in the same column order to enable direct use in setting column names when x_tidy and x_mean are read.

Variables:

> **featureNo**

>> serial number of features in column order, i.e., corresponding the to features column location in the tidy data frame

>> integer

>> 1 .. 66

> **featureDescr**

>> the descriptive name of the feature = column names for the data frame

>> character string

>> variable length
