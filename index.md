# Practical Machine Learning Project
##  Abstract

This is the Writeup of the Pratical Machine Learning Peer Assessment.
We do some preprocessing on the pml-training file, build tree based models, use cross validation, compute out of sample error and predict test cases. 

## Preprocessing

We load the files pml-training.csv and pml-testing.csv into R and do some cleaning. Inspecting the training file we find that there are 19622 observations of 160 variables. In one hundred of these variables 90 percent or more observations
are not available (NA). We drop these variables and result in a data set training with 19622 observations of 60 variables.

We split this training set with the createDataPartition of the caret package
into two parts, one again called training containing 80 percent of the data and subject to train the models, the 
rest called validation for cross validation of the models.

The first seven variables of the training set contain observations not relevant for modelling and are dropped. We finaly have a training set with 11776 obeservations of 53 variables.
