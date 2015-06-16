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

