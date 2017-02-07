#Henrik Husberg, 06.02 2017
#Exercise 3 Data Wrangling - Student alcohol consumption

#Load dplyr
library(dplyr)

#Set working directory so R finds the files
setwd("~/GitHub/IODS-project")

#Read and explore the files
mat <- read.csv("./data/student-mat.csv", sep = ";", header = TRUE)
head(mat)
str(mat)
dim(mat)

por <- read.csv("./data/student-por.csv", sep = ";", header = TRUE)
head(por)
str(por)
dim(por)

#Join the datasets and explore the joined data
#First, select columns to join by
join_by <- c("school", "sex", "age", "address", "famsize",
             "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", 
             "reason", "nursery","internet")

#The use inner_join from dplyr in order to keep
#only students present in both data sets,
#add suffixes for easy reading
mat_por <- inner_join(mat, por, by = c(join_by),
                      suffix = c(".mat", ".por"))

#Explore the new dataset
colnames(mat_por)
glimpse(mat_por)
head(mat_por)
str(mat_por)
dim(mat_por)

mat_por$G2.por
mat_por$G2.mat



#Copy solution from DataCamp exercise to combine
#duplicated answers
alc <- select(mat_por, one_of(join_by))
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]
notjoined_columns

for(column_name in notjoined_columns) {
  # select two columns from 'mat_por' with the same original name
  two_columns <- select(mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

glimpse(alc)

#Create new column alc_use for combined weekday/weekend consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#Create logical column high_use, TRUE for alc_use > 2
alc <- mutate(alc, high_use = alc_use > 2)

alc$alc_use
alc$high_use
alc$G2

glimpse(alc)
head(alc)
str(alc)
dim(alc)

write.csv(alc, file = "./data/alc_data.csv", row.names=FALSE)
read.csv("./data/alc_data.csv") %>% glimpse

