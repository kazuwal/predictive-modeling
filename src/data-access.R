## DATA ACCESS #################################################################################

## Reading CSV structured data #################################################################
urls <- list(
  parking_meters_csv = "https://data.sfgov.org/api/views/9qrz-nwix/rows.csv?accessType=DOWNLOAD",
  parking_meters_json = "https://data.sfgov.org/api/views/9qrz-nwix/rows.json?accessType=DOWNLOAD"
)

datasets <- list(
  show_all = "/Users/gra11/Workspace/R/data/",
  parking_meters_csv = "/Users/gra11/Workspace/R/data/parking.csv",
  parking_meters_json = "/Users/gra11/Workspace/R/data/parking.json"
)


download.file(urls$parking_meters_csv, destfile = "data/parking.csv")
list.files(datasets$show_all)
sf_parking_meters_csv <- datasets$parking_meters_csv
read.csv(sf_parking_meters_csv, sep = ",", header = TRUE)



## Reading unstructured data #################################################################
con <- url("http://bbc.co.uk", "r")
lines <- readLines(con, n= 30)
close(con)
head(lines)

## Reading JSON ##
library(RJSONIO)

download.file(
  urls$parking_meters_json, 
  destfile = datasets$parking_meters_json
)

sf_parking_meters_json <- fromJSON(
  datasets$parking_meters_json
)[[2]]

sapply(
  sf_parking_meters_json, 
  function(x) x[[2]]
)

toString(sf_parking_meters_json)
datasets$parking_meters_json