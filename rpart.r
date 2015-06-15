source("./preProject.r")
library(rpart)
library(rpart.plot)

### make decision tree
fitTree = rpart(class ~ ., data = training, method = "class")
predictTrain = predict(fitTree, newdata = training, type = "class")
## in.error
inerr = 1 - sum(predictTrain == training$class)/ length(training$class)
inerr


predictEval = predict(fitTree, newdata = evaluation, type = "class")

outerr = 1 - sum(predictEval == evaluation$class)/ length(evaluation$class)
outerr

## err = 1 - Accuracy
mtx = confusionMatrix(predictTrain, training$class)
1 - mtx$overall[1]

testPredictTree = predict(fitTree, newdata = pml.testing, type = "class")
testPredictTree

library(rattle)
fancyRpartPlot(fitTree)

