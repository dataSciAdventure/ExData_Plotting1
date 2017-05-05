## Set working directory (uncomment and modify the following line to set directory)
# setwd("~/R_working/ExpDataAnalysisWeek1")

## Detect data - download it and/or unzip it if not found
if (!file.exists("exdata_data_household_power_consumption")){
  zipFile <- "exdata_data_household_power_consumption.zip"
  if (!file.exists(zipFile)){
    zipURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(zipURL,zipFile)
  }
  unzip(zipFile)
}

# Load and subset the data (if it isn't already in memory)
if(!exists("dataFiltered")) {
  dataTextFile <- "exdata_data_household_power_consumption/household_power_consumption.txt"
  dataFull <- read.table(dataTextFile, header=TRUE, sep=";", na="?", colClasses=c(rep("character",2),rep("numeric",7)))
  # Convert date and time values
  dataFull$Time <- strptime(paste(dataFull$Date,dataFull$Time),"%d/%m/%Y %H:%M:%S")
  dataFull$Date <- as.Date(dataFull$Date,"%d/%m/%Y")
  # Subset to only data from Feb. 1 and 2 of 2007
  dataFiltered <- subset(dataFull,Date %in% as.Date(c("2007-02-01","2007-02-02"),"%Y-%m-%d"))
  # Get rid of extra date column and rename the time column to DateTime
  colnames(dataFiltered)[2] <- "DateTime"
  dataFiltered[1] <- NULL
  # Remove variables no longer needed in order to free up memory
  remove("dataFull","dataTextFile")
}

# Generate plot on screen
## specify 1 x 1 columnwise layout (in case a multifigure layout is currently specified)
par(mfcol=c(1,1))
hist(dataFiltered$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)",ylab="Frequency")
# Copy plot to png device
dev.copy(png, filename="plot1.png",units="px",width=480,height=480)
# Close png device
dev.off()

# Uncomment to remove dataFiltered (or leave it commented to allow other scripts to reuse it)
# remove("dataFiltered")