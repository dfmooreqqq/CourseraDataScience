## Exploratory Data Analysis Course Project 1 (from earlier class period)

dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption.txt", dec=".", na.strings="?", nrows=100)
columnclasses<-sapply(dataset, class)
dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption.txt", dec=".", na.strings="?", colClasses=columnclasses)

## This reads the presubsetted by date for speedy use
dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption_subset.txt", dec=".", na.strings="?", nrows=100)
columnclasses<-sapply(dataset, class)
dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption_subset.txt", dec=".", na.strings="?", colClasses=columnclasses)


## using lubridate
library(lubridate)
dataset$datetime<-dmy_hms(paste(dataset$Date, dataset$Time))

dataset$AsDate<-as.Date(dataset$Date)
subsetds<-dataset[dataset$Date=="1/2/2007" | dataset$Date=="2/2/2007",]

## Now, here's where we do the plots
#First Plot
hist(subsetds$Global_active_power, col="red", main="Global Active Power", xlab=c("Global Active Power (kilowatts)")) ## Looks good!
#Second Plot
plot(subsetds$datetime, subsetds$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="") ## Looks good!
#Third Plot
plot(subsetds$datetime, subsetds$Sub_metering_1, type="l", col="black", ylab="Energy Sub metering", xlab="")
points(subsetds$datetime, subsetds$Sub_metering_2, type="l", col="red")
points(subsetds$datetime, subsetds$Sub_metering_3, type="l", col="blue")
legend('topright', legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), lwd=c(2.5,2.5), col=c("black", "red", "blue"), bty="n")

#Fourth Plot
par(mfrow=c(2,2))
plot(subsetds$datetime, subsetds$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="") ## Looks good!
plot(subsetds$datetime, subsetds$Voltage, type="l", ylab="Global Active Power (kilowatts)", xlab="datetime") ## Looks good!
plot(subsetds$datetime, subsetds$Sub_metering_1, type="l", col="black", ylab="Energy Sub metering", xlab="")
points(subsetds$datetime, subsetds$Sub_metering_2, type="l", col="red")
points(subsetds$datetime, subsetds$Sub_metering_3, type="l", col="blue")
legend('topright', legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), lwd=c(2.5,2.5), col=c("black", "red", "blue"), bty="n")
plot(subsetds$datetime, subsetds$Global_reactive_power, type="l", col="black", xlab="datetime")
par(mfrow=c(1,1)) ## returns setting to 1 chart 1 row 1 column