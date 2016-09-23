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
# with a binary classifier algorithm
