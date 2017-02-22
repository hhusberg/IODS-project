#Exercise 4 - Data Wrangling
#Henrik Husberg
#Data wrangling for exercises 4 and 5

#Exercise 4 starts here

library(plyr)

#Read datas:
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Explore datasets:
str(hd)
dim(hd)

str(gii)
dim(gii)

sum_hd <- summary(hd)

sum_gii <- summary(gii)

sum_hd

sum_gii

hdnew <- rename(hd, c("HDI.Rank"="rank", "Country"="country", "Human.Development.Index..HDI."="hdi", "Life.Expectancy.at.Birth"="lifeexp", "Expected.Years.of.Education"="eduexp", "Mean.Years.of.Education"="edumean", "Gross.National.Income..GNI..per.Capita"="gni", "GNI.per.Capita.Rank.Minus.HDI.Rank"="gnirank"))
names(hdnew)

giinew <- rename(gii, c("GII.Rank"="rank", "Country"="country", "Gender.Inequality.Index..GII."="gii", "Maternal.Mortality.Ratio"="matmort", "Adolescent.Birth.Rate"="ado_birth", "Percent.Representation.in.Parliament"="rep_parl", "Population.with.Secondary.Education..Female."="sec_ed_fem", "Population.with.Secondary.Education..Male."="sec_ed_mal", "Labour.Force.Participation.Rate..Female."="labour_fem", "Labour.Force.Participation.Rate..Male."="labour_mal"))
names(giinew)

giinew <- mutate(giinew, sec_ed_F2M = sec_ed_fem/sec_ed_mal, labour_F2M = labour_fem/labour_mal)

join_by <- c("country")

library(dplyr)
human <- inner_join(hdnew, giinew, by = c(join_by), suffix = c(".hd", ".gii"))
names(human)
dim(human)
human
#Exercise 5 starts here
library(stringr)

#Replace strings with numeric values
human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric
human$gni

#Keep only named columns
keep_columns <- c("country", "sec_ed_F2M", "labour_F2M", "eduexp", "lifeexp", "gni", "matmort", "ado_birth", "rep_parl")
human <- select(human, one_of(keep_columns))
names(human)

#Listwise deletion
human <- filter(human, complete.cases(human) == TRUE)

#Remove regions
human$country
last <- nrow(human) - 7
human <- human[1:last, ]
dim(human)

#Define rownames according to country and delete column "country"
rownames(human) <- human$country
human <- subset(human, select = -c(country))
dim(human)

setwd("~/GitHub/IODS-project")
write.csv(human, file = "./data/human.csv", row.names=TRUE)
human_test <- read.csv(file = "./data/human.csv", row.names = 1)
identical(human, human_test)
library(compare)
compare(human, human_test)
