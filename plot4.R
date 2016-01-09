##### DATA SET DOWNLOAD AND MANIPULATION

# Create directory
if(!file.exists("./ExplDataWeek1")) {
  dir.create("./ExplDataWeek1")
}

# Download file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "./ExplDataWeek1/ElectricPower.zip")

# unzip file contents
unzip("./ExplDataWeek1/ElectricPower.zip", exdir = "./ExplDataWeek1")

# Assign file connection
power_file <- "./ExplDataWeek1/household_power_consumption.txt"
fi <- file(power_file)

# Load SQL library
library(sqldf)

# Using SQL to filter on Date, read subset of data into R
power_data <- sqldf("SELECT * FROM fi WHERE Date IN ('1/2/2007','2/2/2007')", 
                    file.format = list(header = TRUE, sep = ";"))
close(fi)

# Set Date and Time to Date and Time classes (only need a single column for both)
# concatenate columns to new Date/Time column
power_data$dateTime <- paste(power_data$Date, power_data$Time)
# convert to date / time
power_data$dateTime <- strptime(power_data$dateTime, "%d/%m/%Y %H:%M:%S")


##### PLOT DATA

# Set parameters for labels and margins (2 by 2 grid)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 2), oma = c(1, 1, 1, 1), cex.main = 0.9, cex.lab = 0.8, 
    cex.axis = 0.7, bg = "transparent")

# plot 4 charts  - will go across and then down because of use of mfrow
with(power_data, {
  # Global Active Power vs. date/time
  plot(dateTime, Global_active_power, xlab = "", 
       ylab = "Global Active Power", type = "l")
  
  # Voltage vs. date/time
  plot(dateTime, Voltage, xlab = "datetime", 
       ylab = "Voltage", type = "l")
  
  # Submetering (all 3) vs. date/time - no border on legend
  plot(dateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
    lines(dateTime, Sub_metering_2, col = "red")
    lines(dateTime, Sub_metering_3, col = "blue")
    legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           col = c("black", "red", "blue"), lwd = 1, cex = 0.7, bty = "n")
  
    # Global reactive power vs. date/time (just copying from assignment despite labels)
  plot(dateTime, Global_reactive_power, xlab = "datetime", type = "l")
})

# Save plots to PNG file
dev.copy(png, file = "./ExplDataWeek1/plot4.png", width = 480, height = 480)
dev.off()