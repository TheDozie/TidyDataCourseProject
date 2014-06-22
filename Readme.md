==================================================================
Getting and Cleaning Data Course Project
==================================================================


------------------------------------------------------------------
The privided input files are as follows:
------------------------------------------------------------------

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


------------------------------------------------------------------
The tidy datasets produced are the following:
------------------------------------------------------------------

- 'README.txt'

- 'tidy_features.txt': List of all features in the tidy data set, in the order of the columns in the tidy data sets

- 'activity_labels.txt': Links the class labels with their activity name -  supplied file unchanged.

- 'x_tidy.txt': The tidy dataset combining test and training data, with only mean and std columns; variables in column order as in tidy_features.txt.

- 'y_tidy.txt': Activity numbers of the tidy dataset, each record corresponding to the rows of the tidy dataset - description corresponds to original activity labels.

- 'x_mean.txt': Average of each variable for each activity, in the same column order as the variables listed in tidy_features.txt.

- 'y_mean.txt': Activity label numbers for the average dataset, in row order as the records and description corresponding to original activities labels.

- 'subject_tidy.txt': Each row identifies the subject who performed the activity for each window sample. Like the provided subject datasets, row order corresponds to the order in the tidy dataset. 


------------------------------------------------------------------
To produce the tidy datasets:
------------------------------------------------------------------

- Run the script "run_analysis.R" stored in the working directory.

    - The script performs the following operations:

    - Read the features/variables into data frame 'features'. The supplied dataset has two columns, define the column names so as to use column names in the processing.

    - Read activity labels into 'activities'; again define column names.

    - We want to keep only the mean and standard deviation measurements. These are the features that have "mean()" and "std()" in their descriptions. Use grep() to extract the indices of the required variables into a vector, 'tokeep'.

    - Rename the variable descriptions to be more meaning:

        - "Acc" = "_accelerometer"

        - "Gyro" = "_gyroscope"

        - "tBody" = "time_body" for time domain body measurements

        - "tGravity" = "time_gravity" for time-domain gravity measurements

        - "fBody" = "frequency_body" for frequency domain body measurements

        - "fGravity" = "frequency_gravity" for frequency-domain gravity measurements

        - "mean()" = "mean"

        - "std()" =  "stdDev"

    - Read the test dataset into data frame xtest. Assign column names from the features list. Delete the unwanted columns.

    - Read corresponding activity numbers and subjects and join into full_test data frame.

    - Read the training datasets and corresponding activity numbers and subjects; delete unwanted columns and create full_train data frame.

    - Append the traning and test datasets with rbind().

    - We don't need information about the subject, so delete the column to get the tidy dataset.

    - Melt the tidy_data, making the activity variable the ID.

    - Then use dcast() to calculate the mean of the other variables over activities.

    - Finally write the datasets to files.
