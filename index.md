# Practical Machine Learning Project
##  Abstract

This is the Writeup of the Pratical Machine Learning Peer Assessment.
We do some preprocessing on the pml-training file, build tree based models, use cross validation, compute out of sample error and predict test cases on the pml-testing set. 

## Preprocessing

We load the files pml-training.csv and pml-testing.csv into R and do some cleaning. Inspecting the training file, we find that there are 19622 observations of 160 variables. In one hundred of these variables 90 percent or more observations
are not available (NA). We drop these variables and result in a data set training with 19622 observations of 60 variables.
The first seven variables of the training set contain observations not relevant for modelling and are dropped. We finally have a training set with 11776 obeservations of 53 variables. 


We split this training set with the createDataPartition() function from the caret package
into two parts. One, again called training, containing 80 percent of the data,
actually used for modelling, the 
rest, called validation, for cross validation of the models.

The r-code for this preprocessing is not included in this report. You may find it in the file
preProject.r of the master branch of the github.com/jrkuehner/jrkuehner.github.io repository.

## Tree Based Model with Package rpart

We load the rpart library and construct a decison tree on the training set
with the rpart() function. The default option control = rpart.control() includes
10 fold cross validation.


```r
library(rpart)
### make decision tree
fitTree = rpart(class ~ ., data = training, control = rpart.control(), method = "class")
### predict on training
predictTrain = predict(fitTree, newdata = training, type = "class")
### predict on validation
predictValid = predict(fitTree, newdata = validation, type = "class")
```
We compute the in sample error manually; the result is 0.2519.


```r
inerr = 1 - sum(predictTrain == training$class)/ length(training$class)
```

We compute the out sample error manually; the result is 0.2543.


```r
outerr = 1 - sum(predictValid == validation$class)/ length(validation$class)
```

We also made a manual cross validation.
The r-code can be found in the file
rpart.r of the master branch of the github.com/jrkuehner/jrkuehner.github.io repository.
This time the in sample error was 0.2573 wheras the out sample error was 0.2648.

We predict on the testing data.


```r
testPredictTree = predict(fitTree, newdata = pml.testing, type = "class")
```

The result is

| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

| B | A | E | D | A | C | D | A | A | A | C | E | C | A | E | E | A | B | B | B |
