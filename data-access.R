## DATA ACCESS #################################################################################

## Reading CSV structured data #################################################################
urls <- list(
  parking_meters_csv = "https://data.sfgov.org/api/views/9qrz-nwix/rows.csv?accessType=DOWNLOAD",
  parking_meters_json = "https://data.sfgov.org/api/views/9qrz-nwix/rows.json?accessType=DOWNLOAD"
)

data_path <- paste0(getwd(), "/data/")
data_path
datasets <- list(
  show_all = data_path,
  parking_meters_csv =  paste0(data_path, "parking.csv"),
  parking_meters_json =  paste0(data_path, "parking.json")
)
datasets$parking_meters_csv

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
