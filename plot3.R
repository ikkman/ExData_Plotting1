library(sqldf)
library(hms)
library(lubridate)

if (!file.exists("./data"))
{
   dir.create("./data")
   
   dirpath <- paste(getwd(), "/data", sep = "")
   
   url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
   
   download.file(url, file.path(dirpath, "data.zip"), method = "curl")
   
   fullpath <- paste(dirpath, "/data.zip", sep = "")
   
   unzip(zipfile = fullpath, exdir = dirpath)
}

# With sqldf Package 
#query <- "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
#hpc <- read.csv.sql("./data/household_power_consumption.txt", sql = query, sep = ";", header = TRUE, stringsAsFactors = FALSE)

# Without sqldf Package
hpc <- read.csv("./data/household_power_consumption.txt", sep = ";", na.strings = "?", stringsAsFactors = FALSE)
hpc <- hpc[hpc$Date == "1/2/2007" | hpc$Date == "2/2/2007", ]

datetime <- paste(hpc$Date, hpc$Time)
datetime <- parse_date_time(datetime, "%d/%m/%Y %H:%M:%S")

#Plot 3
png(file = "plot3.png", width = 480, height = 480)
plot(hpc$Sub_metering_1 ~ datetime, type = "l", xlab = "", ylab = "Energy sub metering")
#lines(hpc$Sub_metering_1 ~ datetime)
lines(hpc$Sub_metering_2 ~ datetime, col = "red")
lines(hpc$Sub_metering_3 ~ datetime, col = "blue")
legend("topright", pch = "_", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
