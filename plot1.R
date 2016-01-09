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

# Set parameters for labels and margins
par(mfrow = c(1, 1), mar = c(4, 4, 4, 4), oma = c(2, 2, 2, 2), cex.main = 0.9, 
    cex.lab = 0.7, cex.axis = 0.7)

# Histogram of the amount of global active power used, 12 breaks and red color, labels
hist(power_data$Global_active_power, col = "red", breaks = 12,
      main = "Global Active Power", xlab = "Global Active Power (kilowatts)",
      ylab = "Frequency")

# Save plot to PNG file
dev.copy(png, file = "./ExplDataWeek1/plot1.png", width = 480, height = 480)
dev.off()