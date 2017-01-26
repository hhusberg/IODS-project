#Henrik Husberg, 26.01 2017. Data wrangling part 1.

#Read data from web.
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#Examine structure and dimension
dim(lrn14)
str(lrn14)
lrn14
#Conclusion: Dataset contains 60 variables and 183 observations.
#Some values seem to range from 1 to 4, most probably items on Likert-type scales.
#Some values seem to range from 1 to 5, most probably scores for tasks.
#Some values seem to be sums of items: attitude, points.

#Exclude observations with 0 points 
lrn14noz <- subset(lrn14, (Points > 0))
lrn14noz
dim(lrn14noz)

#Install needed packages and activate them
install.packages("dplyr")
library(dplyr)

#Select and sum items for deep, stra and surf
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06",  "D15", "D23", "D31")
deep_columns <- select(lrn14noz, one_of(deep_questions))
deep_columns
lrn14noz$deep <- rowSums(deep_columns)
lrn14noz$deep

strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
stra_cols <- select(lrn14noz, one_of(strategic_questions))
stra_cols
lrn14noz$stra <- rowSums(stra_cols)
lrn14noz$stra
dim(lrn14noz)

surf_q <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
surf_cols <- select(lrn14noz, one_of(surf_q))
lrn14noz$surf <- rowSums(surf_cols)

#Check dataframe
head(lrn14noz)

#Select variables of interest to new dataframe
my_dataframe <- select(lrn14noz, age = Age, attitude = Attitude, points = Points, gender, deep, stra, surf)

#Verify dataframe
head(my_dataframe)
dim(my_dataframe)
my_dataframe

#Looking good - tho maybe not the most elegant coding...

#Now set working directory to IODS folder
setwd("~/GitHub/IODS-project")

#...and save the file
write.csv(my_dataframe, file = "./data/learning2014.csv", row.names = FALSE)

#...then read it and weep
read.csv("./data/learning2014.csv")



#Compare dataframes just to be sure
my_dataframe_test <- read.csv("./data/learning2014.csv")
summary(my_dataframe)
summary(my_dataframe_test)
str(my_dataframe)
str(my_dataframe_test)
head(my_dataframe)
head(my_dataframe_test)

identical(my_dataframe, my_dataframe_test)
#Returns FALSE, but summary() seems identical... Oh well.
