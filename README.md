# getdata-cp
Coursera getdata-010 course project

Overall workflow for run_analysis.R:

1. It shall be run inside the "UCI HAR Dataset" directory where it has access to all the data files.
2. Source it in an R console or RStudio
3. Simply run the createTidyData() function
4. An output called "tidyset.txt" shall be produced in the same directory.

The design/implementation details of run_analysis.R:
* It first reads the "features.txt" and remembers the indices and names of only the "mean" and "std" features.
* Reads test and training data sets, taking into consideration subjects also.
* Merge test and training data sets, i.e. perform a full left join (dplyr).
* Aggregate the joined data set by subject and perform "average" function on all other variables.
