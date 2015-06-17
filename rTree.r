source("./preProject.r")

model = train(class ~ .,
    data = training,
    method = "rf",
    trControl = trainControl(method = "cv",
        number = 2,
        allowParallel = TRUE,
        verboseIter = TRUE))

model$finalModel

predict_model = predict(model, newdata = training)
confusionMatrix(predict_model, training$class)

predict_model = predict(model, newdata = validation)
confusionMatrix(predict_model, validation$class)

predict(model, pml.testing)

trellis.par.set(caretTheme())
plot(model)

#### take just some important variables

imp = importance(model$finalModel) > 500


modelImp = train(class ~ .,
    data = training[,imp],
    method = "rf",
    trControl = trainControl(method = "cv",
        number = 2,
        allowParallel = TRUE,
        verboseIter = TRUE))

modelImp$finalModel

predict_modelImp = predict(modelImp, newdata = training)
confusionMatrix(predict_modelImp, training$class)

##predict_model = predict(modelImp, newdata = validation)
##confusionMatrix(predict_modelImp, validation$class)

predict(modelImp, pml.testing)

trellis.par.set(caretTheme())
plot(modelImp)



