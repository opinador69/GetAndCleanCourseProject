# Code Book for de Course Project of Getting and Cleaning Data

The output data is in the data table outDT and written to a file called solution.txt

The first step is read the auxiliary files with the activity names and the headers for the data tables

After this, for each of the two sets of files (test and train):
- Read the data (accelerometer)
- Assign titles to the variables (columns)
- Select the columns we want to use later (those containing "mean" or "std" in the title)
- Read the activity and subject labels
- Combine the data: accelerometer (only desired columns), subject and activities 
The result are 2 data tables named test.full and train.full

Now we combine this 2 files in integratedDT data table

Next step melt the data in a new data table selecting the id fields (sbj and labels (activities)) and the rest
of the columns as measure variables.

With dcast we generate in outDT the summary data table with one line for each combination of subject and activity 
and in it the mean of each of the variables.

# Variables

Most of the variables used are data tables.

The entry data are read in variables named "test.xxxxxx" or "train.xxxxxx" using for the xxxxxx part a short version of the imput file

