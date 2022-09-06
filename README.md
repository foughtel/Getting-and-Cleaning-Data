The run_analysis.R script has the following structure:

1. Looks for the data, and downloads the data set if not available

2. Unzips the .zip file into the appropriate directory

3. Gets the associated labels for the activity and features to use later

4. Sorts the "features" list and filters for just "mean" and "std" 

5. Reads the .txt files and retrieves the features, acivities and subjects
     for train and test and then binds the columns accordingly
     
6. Binds the rows for test and train data sets

7. Cleans up the labels of the features

8. Creates the tidy.txt file based on average of each variable per subject/activity 

