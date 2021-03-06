library("neuralnet") 
library(ISLR) 
data = College View(data) 

#data normalization -  it is good practice to normalize the data before training a neural network. With normalization, data units are eliminated, allowing you to easily compare data from different locations
max_data <- apply(data[,2:18], 2, max) 
min_data <- apply(data[,2:18], 2, min) 
data_scaled <- scale(data[,2:18],center = min_data, scale = max_data - min_data) 


Private = as.numeric(College$Private)-1 
data_scaled = cbind(Private,data_scaled) 

# split the data for training and testing of the network
index = sample(1:nrow(data),round(0.70*nrow(data))) 
train_data <- as.data.frame(data_scaled[index,]) 
test_data <- as.data.frame(data_scaled[-index,]) 
n = names(train_data) 

#writing formulae for dnn
f <- as.formula(paste("Private ~", paste(n[!n %in% "Private"], collapse = " + "))) 

#building model
deep_net = neuralnet(f,data=train_data,hidden=c(5,3),linear.output=F) 
plot(deep_net)

#prediction on test data
predicted_data <- compute(deep_net,test_data[,2:18]) 
print(head(predicted_data$net.result)) 

predicted_data$net.result <- sapply(predicted_data$net.result,round,digits=0) 
table(test_data$Private,predicted_data$net.result) 