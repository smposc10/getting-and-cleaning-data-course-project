# Getting and Cleaning Data Project: Code Book

The run_analysis.R script will create a .txt format output called tidyDataSummaryAvg.txt which is the result of all the steps required for the Getting and Cleaning Data project. Refer to the readme.md file for a quick overview and the purpose of this script.

#### Preparing the Dataset
Before starting any transformation or work, the **dplyr** library is loaded. Using the links provided in the course page (also included in the README.md), a zip file was downloaded and the the dataset `UCI HAR Dataset` is extracted. 

The following variables are then created:
- `features` : uses the data from the *features.txt* file.
- `activities` - uses the data from the *activity_labels.txt* file. Activities include 6 distinct values : WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
- `trainSubjects` - uses the data *subject_train.txt* file. Values range from 1 - 30
- `trainX` - uses the data *X_train.txt* file.
- `trainY` - uses the data *y_train.txt* file.
- `testSubjects` -uses the data *subject_test.txt* file. Values range from 1 - 30
- `testX` - uses the data *X_test.txt* file.
- `testY` - uses the data *y_test.txt* file.

#### Step 1: Merge the training and test sets to create one data set
- `subject` - merges `trainSubject` and `testSubjects` using `rbind()`
- `xData` - merges `trainX` and `testX` using `rbind()`
- `yData` - merges `trainY` and `testY` using `rbind()`

Finally (at least for this step),
- `mergedDataset` - merges `subject`, `xData` and `yData` using `cbind()`

#### Step 2: Extract only the measurements on the mean and standard deviation for each measurement
The `tidyDataSet` variable is created by taking only the subject column, code column, any columns containing "mean" and any columns containing "std".

#### Step 3: Use descriptive activity names to name the activities in the data set. 
The `tidyDataSet` at this point has the code columns with numbers ranging from 1-6. We create the descriptive activity names by associating this numbers with the `activities` variable (where the *activity_labels.txt* resides) to decode the numbers into their respective names.

#### Step 4: Appropriately label the dataset with descriptive variable names.
Using the `names()` function to identify the activities from `tidyDataSet` and `gsub()` to find and replace the new descriptions, the changes were made with the conditions below:
- the `code` title column is renamed as the `activity` column
- `Acc` is renamed as `Accelerometer`
- `Gyro` is renamed as `Gyroscope`
- `Mag` is renamed as `Magnitude`
- any title that starts with a `t` is replaced with `Time`
- any title that starts with a `f` or has `freq` or `Freq` is replaced with `Frequency`
- any title that has `mean` regardless of the case used is renamed as `Mean`
- any title that has `std` regardless of the case used is renamed as `StandardDeviation`
- `angle` is replaced as `Angle` to follow camel casing
- `gravity` is replaced as `Gravity`
- `BodyBody` is considered as a typo error and renamed as `Body`
- cases of `tBody`were considered as `TimeBody` and replaced accordingly.

#### Step 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject.

A new `.txt` file called tidyDataSummaryAvg is generated from  tidyDataSet grouped by each activity and each subject. The file `tidyDataSummaryAvg.txt` file is included in this repository to reflect the results at the time this script was completed and ran.

