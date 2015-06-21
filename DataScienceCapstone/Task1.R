### Task 1 - to do after task0
# Task 1 - Data acquisition and cleaning Help   
# 
# Large databases comprising of text in a target language are commonly used when generating language models for various purposes. In this exercise, you will use the English database but may consider three other databases in German, Russian and Finnish.
# 
# The goal of this task is to get familiar with the databases and do the necessary cleaning. After this exercise, you should understand what real data looks like and how much effort you need to put into cleaning the data. When you commence on developing a new language, the first thing is to understand the language and its peculiarities with respect to your target. You can learn to read, speak and write the language. Alternatively, you can study data and learn from existing information about the language through literature and the internet. At the very least, you need to understand how the language is written: writing script, existing input methods, some phonetic knowledge, etc.
# 
# Note that the data contain words of offensive and profane meaning. They are left there intentionally to highlight the fact that the developer has to work on them.
# 
# Tasks to accomplish
# 1.Tokenization - identifying appropriate tokens such as words, punctuation, and numbers. Writing a function that takes a file as input and returns a tokenized version of it.
# 2.Profanity filtering - removing profanity and other words you do not want to predict.
# 
# Tips, tricks, and hints
# 
# 1.Loading the data in. This dataset is fairly large. We emphasize that you don't necessarily need to load the entire dataset in to build your algorithms (see point 2 below). At least initially, you might want to use a smaller subset of the data. Reading in chunks or lines using R's readLines or scan functions can be useful. You can also loop over each line of text by embedding readLines within a for/while loop, but this may be slower than reading in large chunks at a time. Reading pieces of the file at a time will require the use of a file connection in R. For example, the following code could be used to read the first few lines of the English Twitter dataset:
#     con <- file("en_US.twitter.txt", "r")
# readLines(con, 1)  ## Read the first line of text
# readLines(con, 1)  ## Read the next line of text
# readLines(con, 5)  ## Read in the next 5 lines of text
# close(con)  ## It's important to close the connection when you are done
# 
# See the ?connections help page for more information.
# 
# 
# 2.Sampling. To reiterate, to build models you don't need to load in and use all of the data. Often relatively few randomly selected rows or chunks need to be included to get an accurate approximation to results that would be obtained using all the data. Remember your inference class and how a representative sample can be used to infer facts about a population. You might want to create a separate sub-sample dataset by reading in a random subset of the original data and writing it out to a separate file. That way, you can store the sample and not have to recreate it every time. You can use the rbinom function to "flip a biased coin" to determine whether you sample a line of text or not.


library(R.utils)
setwd("C:\\Users\\damoore\\Documents\\GitHub\\DataScienceCapstone")
setwd("C:\\Users\\Daniel\\Documents\\GitHub\\DataScienceCapstone")

## download and unzip files
if (!file.exists("swiftkey.zip")) {
    dataurl<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    download.file(dataurl, "swiftkey.zip")
    unzip("swiftkey.zip")
}

## load english files
library("clue"); library("tm"); library(wordcloud)

input="final/en_US/en_US.blogs.txt"
con<-file(input)
a<-countLines(input)
sel<-a[1]*0.1 # we're only going to read 10% of lines
remaining<-a[1]
recs<-sort(sample(1:remaining, sel))
skip<-diff(c(1,recs))-1
enBlogssample<-vector('character',sel)
for (i in 1:sel) {
    enBlogssample[i]<-scan(input,what="", sep="\n", skip=skip[i], n=1, quiet=TRUE)
    
}
close(con)

input="final/en_US/en_US.news.txt"
con<-file(input)
a<-countLines(input)
sel<-a[1]*0.1 # we're only going to read 10% of lines
remaining<-a[1]
recs<-sort(sample(1:remaining, sel))
skip<-diff(c(1,recs))-1
enNewssample<-vector('character',sel)
for (i in 1:sel) {
    enNewssample[i]<-scan(input,what="", sep="\n", skip=skip[i], n=1, quiet=TRUE)
    
}
#en_US_blogs<-readLines(con)
close(con)

input="final/en_US/en_US.twitter.txt"
con<-file(input)
a<-countLines(input)
sel<-a[1]*0.1 # we're only going to read 10% of lines
remaining<-a[1]
recs<-sort(sample(1:remaining, sel))
skip<-diff(c(1,recs))-1
enTwittersample<-vector('character',sel)
for (i in 1:sel) {
    enTwittersample[i]<-scan(input,what="", sep="\n", skip=skip[i], n=1, quiet=TRUE)
    
}
#en_US_blogs<-readLines(con)
close(con)

# mycorpustest<-Corpus(a) # Takes a while ~300s for user on full df
# mycorpustest<-tm_map(mycorpustest, function(x) removeWords(x, stopwords("SMART")))
# tdm<-TermDocumentMatrix(mycorpustest, control=list(removePunctuation = TRUE, stopwords = TRUE, tolower=TRUE))

blog<-enBlogssample
blog<-tolower(blog);blog<-removePunctuation(blog);#a<-removeWords(a, stopwords("SMART"))
blog_token<-MC_tokenizer(blog)

news<-enNewssample
news<-tolower(news);blog<-removePunctuation(news);#a<-removeWords(a, stopwords("SMART"))
news_token<-MC_tokenizer(news)

twitter<-enTwittersample
twitter<-tolower(twitter);twitter<-removePunctuation(twitter);#a<-removeWords(a, stopwords("SMART"))
twitter_token<-MC_tokenizer(twitter)


library("lda", lib.loc="~/R/win-library/3.1")
bloglex<-lexicalize(blog)
bloglex$lexicon
to.keep<-bloglex$vocab[word.counts(bloglex$documents,bloglex$vocab) >= 2]
bloglex<-lexicalize(blog, vocab=to.keep)



