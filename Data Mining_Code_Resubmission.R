bankdata = read.csv('loan_data.csv',sep=',',header = T)
summary(bankdata)

### Explorartory Data Analysis
sapply(bankdata, function(x) sum(is.na(x)))
sum(duplicated(bankdata))

str(bankdata)

# Convert the columns 
bankdata$credit.policy <- as.factor(bankdata$credit.policy)
bankdata$inq.last.6mths <-as.factor(bankdata$inq.last.6mths)
bankdata$delinq.2yrs <- as.factor(bankdata$delinq.2yrs)
bankdata$pub.rec <- as.factor(bankdata$pub.rec)
bankdata$not.fully.paid <- as.factor(bankdata$not.fully.paid)

# Histograms
library(ggplot2)
ggplot(bankdata, aes(fico)) + geom_histogram(aes(fill=credit.policy), color='black') + theme_bw()
ggplot(bankdata, aes(fico)) + geom_histogram(aes(fill=not.fully.paid), color='black') + theme_bw()
ggplot(bankdata, aes(factor(purpose))) + geom_bar(aes(fill=not.fully.paid), position='dodge') + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggplot(bankdata, aes(int.rate, fico)) + geom_point(aes(color=not.fully.paid), alpha=0.5) + theme_bw()


## SVM
library(rpart.plot)
library(rpart)
library(e1071)
library(caret)
library(caTools)
library(rmarkdown)
set.seed(0)

# Split the data for Test and Train
sample <-sample.split(bankdata$not.fully.paid, SplitRatio = 0.7)
train <- subset(bankdata, sample == TRUE)
test <- subset(bankdata, sample == FALSE)

# Without Tuning Prediction Value
model <- svm(not.fully.paid ~., data = train[1:14])
summary(model)

# Confusion Matrix
predict.values <- predict(model,test[1:13])
table(predict.values, test$not.fully.paid)

# With Tuning the Data
tuned.svm <-svm(not.fully.paid ~., data=train[1:14], kernal='radial', cost =70, gamma=0.2)
predicted.values <- predict(tuned.svm, test[1:13])
table(predicted.values, test$not.fully.paid)

# Accuracy
accuracy <- (2112 + 91)/(2112 + 369 + 301 + 91)
print(accuracy)

### Random Forest

library(randomForest)

intrain <- createDataPartition(bankdata$not.fully.paid, p= 0.70, list = FALSE)
training <- bankdata[intrain,]
testing <- bankdata[-intrain,]
training$not.fully.paid <- as.factor(training$not.fully.paid)
rf_fit <-randomForest(not.fully.paid ~ .,  
                      data = training,  
                      importance = TRUE) 
rf_pred=predict(rf_fit,testing)
conf_mat=confusionMatrix(rf_pred,as.factor(testing$not.fully.paid))
print(conf_mat)

