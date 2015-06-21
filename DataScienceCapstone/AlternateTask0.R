## Task 0 Alternate File
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


setwd("C:\\Users\\damoore\\Documents\\GitHub\\DataScienceCapstone")
setwd("C:\\Users\\Daniel\\Documents\\GitHub\\DataScienceCapstone")

## download and unzip files
if (!file.exists("swiftkey.zip")) {
    dataurl<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    download.file(dataurl, "swiftkey.zip")
    unzip("swiftkey.zip")
}

## load blog files
library("clue"); library("tm"); library(wordcloud)
con<-file("final/de_DE/de_DE.blogs.txt")
de_DE_blogs<-readLines(con)
close(con)

con<-file("final/en_US/en_US.blogs.txt")
en_US_blogs<-readLines(con)
close(con)

con<-file("final/fi_FI/fi_FI.blogs.txt")
fi_FI_blogs<-readLines(con)
close(con)

con<-file("final/ru_RU/ru_RU.blogs.txt")
ru_RU_blogs<-readLines(con)
close(con)




### an initial look - do a wordcloud
df<-data.frame(V1=en_US_blogs, stringsAsFactors = FALSE)
testdf<-data.frame(V1=sample(en_US_blogs, 10000), stringsAsFactors = FALSE)
#testdf<-df
mycorpustest<-Corpus(DataframeSource(testdf)) # Takes a while ~300s for user on full df
# mycorpustest<-tm_map(mycorpustest, removePunctuation)
# mycorpustest<-tm_map(mycorpustest, tolower)
mycorpustest<-tm_map(mycorpustest, function(x) removeWords(x, stopwords("SMART")))
tdm<-TermDocumentMatrix(mycorpustest, control=list(removePunctuation = TRUE, stopwords = TRUE, tolower=TRUE))
m<-as.matrix(tdm)
v<-sort(rowSums(m), decreasing=TRUE)
d<-data.frame(word=names(v), freq=v)
pal<-brewer.pal(9, "BuGn")

pal<-pal[-(1:2)]
png("wordcloud3.png", width=1280, height=800)
wordcloud(d$word, d$freq, scale=c(8,0.3), min.freq=2, max.words=100, random.order=T, rot.per=0.15, colors=pal, vfont=c("sans serif", "plain"))
dev.off()