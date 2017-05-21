library(e1071)

plot(iris)

head(iris)

# Sepal.Width - Species overlap hard to draw hyperplane
plot(iris$Sepal.Length, iris$Sepal.Width, col=iris$Species)
# Petal.Width - Less overlap + clearer cluster seperation
plot(iris$Petal.Length, iris$Petal.Width, col=iris$Species)

# Sample of 100 values between 1 & 150
s = sample(150, 100) 

col = c("Petal.Length", "Petal.Width", "Species")

iris.train = iris[s, col]
iris.test = iris[-s, col]

# As "linear", scale is FALSE
linear.svm.fit = svm(Species ~., data= iris.train, kernel="linear", cost = .1, scale= FALSE)

# View initial plot
plot(linear.svm.fit, iris.train)

# Cross validation
best.cost.param = tune(svm, Species ~., data=iris.train, kernel="linear", ranges=list(cost=c(0.001, 0.01, 0.1, 1, 10, 100)))
summary(best.cost.param)

# Aplly best cost paramater.. in this case 10
linear.svm.fit = svm(Species ~., data= iris.train, kernel="linear", cost = 10, scale= FALSE)


# View updated plot
plot(linear.svm.fit, iris.train) 

iris.prediction = predict(linear.svm.fit, iris.test, type="class")
plot(iris.prediction)

iris.test.species = iris.test[, 3]

table(iris.prediction, iris.test.species)

# Prediction accuracy varies between 92 -92% accuracy
mean(iris.prediction == iris.test.species) 

