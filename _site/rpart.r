
source("./preProject.r")
library(rpart)
library(rpart.plot)
library(rattle)
#####

### make decision tree
fitTree = rpart(class ~ ., data = training,
    control = rpart.control(),
    method = "class")

trellis.par.set(caretTheme())
fancyRpartPlot(fitTree)

predictTrain = predict(fitTree, newdata = training, type = "class")
## in.error
inerr = 1 - sum(predictTrain == training$class)/ length(training$class)
inerr

predictValid = predict(fitTree, newdata = validation, type = "class")

outerr = 1 - sum(predictValid == validation$class)/ length(validation$class)
outerr

## err = 1 - Accuracy
mtx = confusionMatrix(predictTrain, training$class)
1 - mtx$overall[1]

mtx1 = confusionMatrix(predictValid, validation$class)
1 - mtx1$overall[1]

#### manual cross validation

n = nrow(training); n
K = 10
len = n %/% K; len
set.seed(1234)
random = runif(n); random
rk = rank(random); rk
blk = (rk - 1) %/% len + 1; blk
blk = as.factor(blk); blk
summary(blk)

all.err = numeric(0)

for (k in 1:K) {
    tree = rpart(class ~ ., data = training[blk != k, ], method = "class")
    pred = predict(tree, newdata = training[blk == k, ], type = "class")
    mc = table(training$class[blk == k], pred)
    err = 1.0 - (mc[1,1] + mc[2,2] + mc[3,3] + mc[4,4] + mc[5,5])/sum(mc)
    all.err = rbind(all.err, err)
}
all.err
mean(all.err)

#### on validation

m = nrow(validation); m
K = 10
len = m %/% K; len
set.seed(1234)
random = runif(m); random
rk = rank(random); rk
blk = (rk - 1) %/% len + 1; blk
blk = as.factor(blk); blk
summary(blk)


all.outerr = numeric(0)

for (k in 1:K) {
    tree = rpart(class ~ ., data = validation[blk != k, ], method = "class")
    pred = predict(tree, newdata = validation[blk == k, ], type = "class")
    mc = table(validation$class[blk == k], pred)
    outerr = 1.0 - (mc[1,1] + mc[2,2] + mc[3,3] + mc[4,4] + mc[5,5])/sum(mc)
    all.outerr = rbind(all.outerr, outerr)
}

all.outerr
mean(all.outerr)


testPredictTree = predict(fitTree, newdata = pml.testing, type = "class")
testPredictTree

library(rattle)
fancyRpartPlot(fitTree)

