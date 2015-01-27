#plot3
dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption.txt", dec=".", na.strings="?", nrows=100)
columnclasses<-sapply(dataset, class)
dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption.txt", dec=".", na.strings="?", colClasses=columnclasses)
## using lubridate
library(lubridate)
dataset$datetime<-dmy_hms(paste(dataset$Date, dataset$Time))

dataset$AsDate<-as.Date(dataset$Date)
subsetds<-dataset[dataset$Date=="1/2/2007" | dataset$Date=="2/2/2007",]

#Third Plot
png(filename="plot3.png", width=480, height=480)
    plot(subsetds$datetime, subsetds$Sub_metering_1, type="l", col="black", ylab="Energy Sub metering", xlab="")
    points(subsetds$datetime, subsetds$Sub_metering_2, type="l", col="red")
    points(subsetds$datetime, subsetds$Sub_metering_3, type="l", col="blue")
    legend('topright', legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), lwd=c(2.5,2.5), col=c("black", "red", "blue"), bty="n")
dev.off()