### Task 0 script

# Tasks to accomplish
# 1. Obtaining the data - Can you download the data and load/manipulate it in R?
# 2. Familiarizing yourself with NLP and text mining - Learn about the basics of natural language processing and how it relates to the data science process you have learned in the Data Science Specialization.

# Questions to consider
# 1. What do the data look like?
# 2. Where do the data come from?
# 3. Can you think of any other data sources that might help you in this project?
# 4. What are the common steps in natural language processing?
# 5. What are some common issues in the analysis of text data?
# 6. What is the relationship between NLP and the concepts you have learned in the Specialization?

temp<-tempfile()
download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", temp)
temp<-file("C:\\Users\\Daniel\\Downloads\\Coursera-SwiftKey.zip")

close(temp)


setwd("C:\\Users\\Daniel\\Documents\\GitHub\\DataScienceCapstoneProject")
setwd("C:\\Users\\damoore\\Documents\\GitHub\\DataScienceCapstoneProject")
if (!file.exists("swiftkey.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "swiftkey.zip")
}

de_DE <- read.table(unz("swiftkey.zip", "final\\de_DE\\de_DE.blogs.txt"))