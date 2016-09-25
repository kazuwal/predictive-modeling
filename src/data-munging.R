## Revise variable names #######################################################################

df <- data.frame("Address"= character(0), "Phone"=character(0), Location.1=character(0))

names(df)

split_names <- strsplit(names(df),"\\.")
class(split_names) #list
class(split_names[1]) #list
class(split_names[[1]]) #character

split_names[[3]][2] #3rd list second element

first_element <- function(x){x[1]}

sapply(split_names, first_element) #removes the "1"

names(df) <- sapply(split_names, first_element) #overrites df

## Create new variables ########################################################################

# Use the airquality data set and add a new field, ozoneRanges. This field will take the current
# quantitative variable Ozone and calculate a corresponding range based on its value.

airquality$Ozone[1:10] #First 10 rows of Ozone values

seq(0, 10, by=2) #Seqence from 1 -> 10 in increments of 2

# Each value in the first vector will be grouped in the range of each pair of numbers
# in second vector eg age 19 is in the range (10,25]
cut(c(10,33,44,85), c(9,18,27,40,41,50,80,90))

ozoneRanges <- cut(airquality$Ozone, seq(0, 200, by=25))

#Shows us there are 5 between (0,25] and 3 between (25, 50] etc
table(ozoneRanges, useNA="ifany")

#Factors are what R interperets as categorical variables
class(ozoneRanges)


airquality$ozoneRanges <- ozoneRanges
head(airquality)
#Now has new column that is the range that the ozone temp is in
airquality

## Discreteize numeric values ##################################################################

# On occasion, you’ll be presented with a numeric variable in a data set that would be more convenient
# for machine learning if the continuous values were represented as discrete “ranges” of values instead.


data(iris)

buckets <- 10
max_sep_len <- max(iris$Sepal.Length)
min_sep_len <- min(iris$Sepal.Length)

#From max sep len to min sep len by increments of 0.36
cut_points <- seq(
  from = min_sep_len,
  to = max_sep_len,
  by = ( max_sep_len - min_sep_len ) / buckets )

cut_points


cut_sep_len <- cut(
  iris$Sepal.Length,
  breaks = cut_points,
  include.lowest = TRUE
)
#View the grouping of ranges
table(cut_sep_len)

#New data frame
iris_length_ranges <- data.frame(
  cont_sep_len = iris$Sepal.Length,
  disc_sep_len = cut_sep_len
)

iris_length_ranges

## Date handling #####################################################################################
# What we’d like to do as part of our data munging is to combine the date and time variables into a single
# R date object that includes the time

library(lubridate)

lakers_df <- lakers

play_date <- lakers_df$date[1]
play_time <- lakers_df$time[1]

play_date_time <- paste(play_date, play_time)

parsed_play_date_time <- parse_date_time(
  play_date_time, "%y-%m-%d %H. %M"
)

class(parsed_play_date_time) #POSIXct
lakers_df$date <- ymd(lakers_df$date)
class(lakers_df$date) #Now POSIXct

#Update lakers_df with new column play_date_time and populate with the function output
lakers_df$play_date_time <- parse_date_time(
  paste(lakers_df$date, lakers_df$time),
  "%y-%m-%d %H. %M"
)

lakers_df$date
View(lakers_df)

## Binary Categorical Variables ######################################################################
# When using certain machine learning algorithms, it is more convenient to have a categorical variable
# (called factors in R) represented as multiple binary variables. You might want to do this for use
# with a binary classifier algorithm.

#Levels filters the individual types of factor within a given sequence. Think Set ie no dupes
cat_species <- levels(iris$Species)

# We’d like to create three new binary variables, each representing a TRUE or FALSE condition
# for the Species variable value of the record.

binary_species <- function(c) {iris$Species == c}
new_vars <- sapply(cat_species, binary_species) #Inferes the column names as the contents of cat_species
new_vars


new_vars

bin_matrix <- cbind(iris[,c('Species')], new_vars)
bin_matrix

#df[r, c]
iris[,c('Species')] # Retrieves the Species column from the iris dataframe

bin_matrix[50:55,]

#Copy iris
bin_iris <- iris

#Add new columns
bin_iris$setosa <- bin_matrix[,2]
bin_iris$versicolor <- bin_matrix[,3]
bin_iris$virginica <- bin_matrix[,4]

names(bin_iris)
bin_iris # 1 = TRUE 0 = FALSE


## MERGE DATASETS #####################################################################################
# When you receive two or more data sets of similar structure, you may need to combine 
# them to obtain the data set you’ll use for machine learning purposes. The data 
# munging phase is a good time to merge the data sets to form a new data set 
# containing records from the contributing pieces

data_frame_one <- data.frame(
  cust_id=c(1:6),
  product=c(
    rep("Mouse", 3), rep("Keyboard", 3)
  )
)

data_frame_two <- data.frame(
  cust_id=c(2,4,5),
  state=c(rep("California", 2), rep("CustID", 1))
)

data_frame_one
data_frame_two

#Left outer join
merge(
  data_frame_one,
  data_frame_two,
  all.x = TRUE
)

#Right outer join
merge(
  data_frame_one,
  data_frame_two,
  all.y = TRUE
)

#Inner join
merge(
  data_frame_one,
  data_frame_two,
  all = FALSE
)

#Outer join
merge(
  data_frame_one,
  data_frame_two,
  all.y = TRUE
)

## Ordering Datasets ###################################################################################

# As you’re evaluating your data sets for a new data science project, you’ll often notice an ordering of 
# the data that is natural to the problem being solved with machine learning

#Order the len column
order(ToothGrowth$len)

#Update data frame with ordered rows
sorted_data <- ToothGrowth[order(ToothGrowth$len),] 

# Order the ToothGrowth data set by two variables. Think of 
# supp as the primary sort key and len as the 
# secondary sort key

sorted_data <- ToothGrowth[order(ToothGrowth$len, ToothGrowth$sup),]

## Misshapen datasets ###################################################################################

# Many times you’ll receive a data set that is “misshapen” for use with a machine 
# learning algorithm  For these instances, you can use the melt() function found 
# in the reshape2 package.


# Wide data has a column for each variable. For example, this is wide-format data:

#   ozone solar.r wind temp month day
# 1    41     190  7.4   67     5   1
# 2    36     118  8.0   72     5   2
# 3    12     149 12.6   74     5   3
# 4    18     313 11.5   62     5   4
# 5    NA      NA 14.3   56     5   5
# 6    28      NA 14.9   66     5   6

# And this is long-format data:

#   month day climate_variable climate_value
# 1     5   1            ozone            41
# 2     5   2            ozone            36
# 3     5   3            ozone            12
# 4     5   4            ozone            18
# 5     5   5            ozone            NA
# 6     5   6            ozone            28


# It turns out that you need wide-format data for some types of data analysis and 
# long-format data for others. In reality, you need long-format data much more 
# commonly than wide-format data. For example, ggplot2 requires long-format data 
# (technically tidy data), plyr requires long-format data, and most modelling 
# functions (such as lm(), glm(), and gam()) require long-format data. But people 
# often find it easier to record their data in wide format.

# Wide- to long-format data: the melt function

# Assumes that all columns with numeric values are variables with values
melt(airquality)

names(airquality) <- tolower(names(airquality))

# id.variables are the variables that identify individual rows of data.
aql <- melt(airquality, id.vars = c("month", "day"),
  variable.name = "climate_variable", 
  value.name = "climate_value")
head(aql)


# The dplyr package is a valuable tool for the data munging process, providing the means to filter, 
# select, restructure, and aggregate tabular data in R.

install.packages("dplyr")
library(dplyr)
data(ToothGrowth)
tooth_growth_df <- tbl_df(ToothGrowth)

# Filter on predicate
filter(
  tooth_growth_df, 
  len == 11.2 & 
  supp =="VC" 
)

# Group the supp to together into individual groups and order their corresponding len in descending order
arrange(
  tooth_growth_df,
  supp,
  desc(len)
)

# Select subset of data
select(
  tooth_growth_df,
  dose,
  supp
)

#Create a new column that is a numeric instance of the supp column
tooth_growth_df <- mutate(
  tooth_growth_df,
  supp_num = as.numeric(supp)
)

# TODO revise attach(... )
attach(
  tooth_growth_df
)

# TODO revise tilde ~
plot(len ~ dose, pch = supp_num)


