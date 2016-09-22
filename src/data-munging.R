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

ozoneRanges <- cut(airquality$Ozone[1:10], seq(0, 200, by=25))
ozoneRanges
#Revise cut() function
cut(c(1,3,3), c(1,2,3))
