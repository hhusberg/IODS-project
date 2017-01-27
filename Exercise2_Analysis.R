#Read data from local file
learning2014 <- read.csv("./data/learning2014.csv")

#Getting to know the data
head(learning2014)
dim(learning2014)
summary(learning2014)

#Getting graphical
library(ggplot2)
library(GGally)

#Plot matrix for all variables
p <- ggpairs(learning2014, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))
p

#Run multiple regressions regressing attitude, deep and surf on points

model1 <- lm(points ~ attitude + deep + surf, data = learning2014)
summary(model1)

#Run model with only significant regressors included

model2 <- lm(points ~ attitude, data = learning2014)
summary(model2)

#Plot the residuals to see if model is valid
par(mfrow = c(2,2))
plot(model2)

#Plot the regression line and interpret results
qplot(attitude, points, data = learning2014) + geom_smooth(method = "lm")
