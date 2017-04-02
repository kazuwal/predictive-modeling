library(e1071)
data("BreastCancer")

brest.cancer <- BreastCancer
cancer.class <- brest.cancer$Class

# try to predict what class of cancer using 
# all other features as predictors '.'

sample.size <- nrow(brest.cancer)

# .6 for training set
train.size <- round(sample.size*0.6)
# .4 for test set
test.size <- round(sample.size*0.4)
indexes <- sample(sample.size, train.size)
train.data <- brest.cancer[indexes,]
test.data <- brest.cancer[-indexes,]


fit <- naiveBayes(train.data$Class ~., data=train.data)
predict.fit <- predict(fit, newdata=test.data) #Fix

