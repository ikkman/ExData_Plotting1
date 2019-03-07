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

#Plot 4
png(file = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2), mar = c(4, 4, 0.5, 0.5))
# Left-Up Plot Graph
plot(hpc$Global_active_power ~ datetime, type = "l", xlab = "", ylab = "Global Active Power")
# Right-Up Plot Graph
plot(hpc$Voltage ~ datetime, type = "l", ylab = "Voltage")
# Left-Down Plot Graph
plot(hpc$Sub_metering_1 ~ datetime, type = "l", xlab = "", ylab = "Energy sub metering")
#lines(hpc2$Sub_metering_1 ~ datetime)
lines(hpc$Sub_metering_2 ~ datetime, col = "red")
lines(hpc$Sub_metering_3 ~ datetime, col = "blue")
legend("topright", pch = "_", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
# Right-Down Plot Graph
plot(hpc$Global_reactive_power ~ datetime, type = "l", ylab = "Energy sub metering")

dev.off()
