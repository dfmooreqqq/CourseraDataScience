## Load Data
library(date)
library(lubridate)
library(lattice)
library(plyr)
setwd("C:\\Users\\Daniel\\Documents\\GitHub\\RepData_PeerAssessment1")
activity<-read.csv("activity.csv", colClasses=c("integer", "character", "integer"))
activity$intervalstr<-formatC(activity$interval, width=4, format="d", flag="0")
activity$timeofday<-strptime(activity$intervalstr, "%H%M")


## Mean steps per day
summarybyday <- ddply(activity, .(date), summarize, sum = sum(steps))
hist(summarybyday$sum)
meanbyday<-mean(summarybyday$sum, na.rm=TRUE)
medianbyday<-median(summarybyday$sum, na.rm=TRUE)
sprintf("The mean total number of steps taken per day is %f", meanbyday)


## Avg daily activity pattern
summarybytime <- ddply(activity, .(timeofday, intervalstr), summarize, mean = mean(steps, na.rm=TRUE))
plot(summarybytime$timeofday,summarybytime$mean, type='l', xlab="Time of day", ylab="Mean number of steps")
maxinterval<-summarybytime$intervalstr[which.max(summarybytime$mean)]
sprintf("The time interval with, on average, the most number of steps is %s", maxinterval)


## Impute missing values
sprintf("There are %4.0f missing values in the data set", sum(is.na(activity$steps)))
# strategy to use - just taking the mean of the non-missing values for that five minute interval across all the days - this will fill in the average daily pattern
activitynona<-activity
for(i in 1:length(activitynona$steps)){
    if(is.na(activitynona$steps[i])){
        activitynona$steps[i]<-summarybytime$mean[summarybytime$intervalstr==activitynona$intervalstr[i]]
    }
}
summarybydaynona <- ddply(activitynona, .(date), summarize, sum = sum(steps))
hist(summarybydaynona$sum, xlab="", main="Steps per day")
meanbydaynona<-mean(summarybydaynona$sum, na.rm=TRUE)
medianbydaynona<-median(summarybydaynona$sum, na.rm=TRUE)
sprintf("The mean total number of steps taken per day is %5.0f (rounded down with NAs imputed)", meanbydaynona)
sprintf("The median total number of steps taken per day is %5.0f (rounded down with NAs imputed)", medianbydaynona)


## Differences between weekdays and weekends
activity$weekday<-weekdays(ymd(activity$date))
for(i in 1:length(activity$weekday)){
    if(activity$weekday[i] %in% c("Sunday", "Saturday")){
        activity$daycategory[i]="Weekend"
    }
    else {
        activity$daycategory[i]="Weekday"
    }
    
}
activity$daycategory <- as.factor(activity$daycategory)
summarybyweekend <- ddply(activity, .(timeofday, interval, intervalstr, daycategory), summarize, mean = mean(steps, na.rm=TRUE))

summarybyweekend$timeredone<-as.POSIXct(summarybyweekend$timeofday, format="%H:%M")

xyplot(mean~timeredone | daycategory, summarybyweekend, main="Comparison of Activity Pattern on Weekdays to Weekends", xlab="time of day", ylab="mean number of steps", type="l", scales = list("alternating"=FALSE, "format"="%H:%M"))


## 