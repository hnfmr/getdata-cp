
namify <- function(x) {
  x <- gsub("[[:punct:]]", " ", x)
  x <- gsub("[^[:alpha:]]", " ", x)
  x <- gsub("^\\s+|\\s+$", "", x)
  x <- gsub("\\s{2,3}", " ", x)
  x <- gsub("\\s", "_", x)
  x
}

# mean and std indicies as in feature file
msIndices <- function(fn) {
  lines <- readLines(fn)
  
  fIndex <- numeric()
  fNames <- character()
  for (l in seq_along(lines)) {
    text = lines[l]
    if ( grepl("mean", text)
          || grepl("std", text))
    {
      fIndex <- c(fIndex, l)
      fNames <- c(fNames, namify(text))
    }
  }
  
  list(fIndex, fNames)
}

# 1. merge test/train sets
# 2. aggregate on subjects
createTidyData <- function() {
  testFn = "test/X_test.txt"
  trainFn = "train/X_train.txt"
  testSubj = "test/subject_test.txt"
  trainSubj = "train/subject_train.txt"
  featureFn = "features.txt"
  
  result <- msIndices(featureFn)
  fIndices <- result[[1]]
  fNames <- result[[2]]
  
  test <- read.table(testFn)
  train <- read.table(trainFn)
  testSubjects <- read.table(testSubj)
  trainSubjects <- read.table(trainSubj)
  
  require(dplyr)
  test <- mutate(select(test, fIndices), subject=testSubjects[,1])
  train <- mutate(select(train, fIndices), subject=trainSubjects[,1])
  
  require(plyr)
  joined <- join(x=test, y=train, type="full")
  
  colnames(joined) <- c(fNames, "subject")

  df <- aggregate(. ~ subject, joined, mean)
  write.table(df, file="tidyset.txt", row.names=F)
}

