#### preProject.r
#### Do all the preprocessing
rm(list = ls())
set.seed(1234)
library(caret)

### read csv
pml.training = read.csv("pml-training.csv", na.string = c("NA", "#DIV/0!"))
pml.testing = read.csv("pml-testing.csv", na.string = c("NA", "#DIV/0!"))
names(pml.training)[160] = "class"
names(pml.testing)[160] = "class"

### are there NA's
table(colSums(is.na(pml.training)))

### yes, lots
### find cols without NAs
nNACols = colSums(is.na(pml.training)) == 0

#### save cols without, NAs drop first 7 cols
training = pml.training[, nNACols]; dim(training)
training = training[, -(1:7)]
### Should we do this with testing??
### testing  = testing[, naCol]; dimtesting)

### Split pml.training in training and validating 
trainIndex <- createDataPartition(y=pml.training$class, p=0.6, list=FALSE)
training <- training[trainIndex,]
validation <- training[-trainIndex,]

### Take away columns 1 through 7
### training = training[, -(1:7)]
dim(training)

### Are there near zero variances
nearZeroVar(training)
### No

