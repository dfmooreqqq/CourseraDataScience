#plot2
dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption.txt", dec=".", na.strings="?", nrows=100)
columnclasses<-sapply(dataset, class)
dataset<-read.csv2("C:\\Users\\damoore\\SkyDrive\\Documents\\Education\\Coursera Data Science Track\\Exploratory Data Analysis\\Course Project 1\\household_power_consumption.txt", dec=".", na.strings="?", colClasses=columnclasses)
## using lubridate
library(lubridate)
dataset$datetime<-dmy_hms(paste(dataset$Date, dataset$Time))

dataset$AsDate<-as.Date(dataset$Date)
subsetds<-dataset[dataset$Date=="1/2/2007" | dataset$Date=="2/2/2007",]

#Second Plot
png(filename="plot2.png", width=480, height=480)
    plot(subsetds$datetime, subsetds$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="") ## Looks good!
dev.off()