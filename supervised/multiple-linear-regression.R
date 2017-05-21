library(car)

data("Prestige")

summary(Prestige)

na_omit_prestige <- na.omit(Prestige) 

#Numberof observations
num_obs <- nrow(na_omit_prestige)

#60% for training set 
num_train <- round(num_obs*0.6)

#Set seed for reproducible results
set.seed(333)

#Create an index
indx <- sample(num_obs, num_train)

train_prestige <- na_omit_prestige[indx,]
test_prestige <- na_omit_prestige[-indx,]

# Some quick exploratory data analysis on training set by plotting the response variable
# in our case here (prestige) against several other predictors to check for linear 
# relationships

#No trend
plot(train_prestige$prestige, train_prestige$income)

#Trend 
plot(train_prestige$prestige, train_prestige$education)

#No trend
plot(train_prestige$prestige, train_prestige$women)

# ~ . means to use all of the other variables as predictors
fit <- lm(formula = prestige ~ ., data = train_prestige)

# Features not marked with at least one asterisk can be safely ignored.
summary(fit)

plot(fit$fitted, fit$residuals)

prediction <- predict(fit, newdata = test_prestige)

predict(fit, data.frame(education=c(100, 200, 300), income=c(13,45,66), women=c(11,22,3), census=c(111,2,4), type=c("prof","prof","prof")))

cor(prediction, test_prestige$prestige)


