install.packages("RISmed")
library(RISmed)

## week 4 notes
## 1. Obtain data for TM
# Corrected EUtilsSummary() call
# The given mindate and maxdate parameters no longer work with the PubMed API
# Taking an alt route to obtaining date restricted results via the query parameter
# Could also pull all records and then filter by desired date, but with 1000 max records per 
# query, we may end up with no results in our desired date ranges

search_topic <- "opioid"

search_query <- EUtilsSummary(
  query = "opioid AND 2021:2022[dp]",  # [dp] filters by publication date
  db = "pubmed",
  retmax = 1000
)

summary(search_query)

## 2. EUtilsGet() usage to obtain raw data
# The records obtained included an NA value for the first AbstractText field
# I've removed those here so we can see a nicer result

records <- EUtilsGet(search_query)

# Convert to a data frame
pubmed_data <- data.frame(
  'Title' = ArticleTitle(records),
  'Abstract' = AbstractText(records),
  stringsAsFactors = FALSE  # Ensure characters are not converted to factors
)

# Remove rows where either Title or Abstract is NA
pubmed_data_clean <- na.omit(pubmed_data)

# Check results
colnames(pubmed_data_clean)
nrow(pubmed_data_clean)
head(pubmed_data_clean, 1)

## 3. Wrangling data 
# Use only abstract
pubmed_data2 <- data.frame('Abstract'=AbstractText(records))
str(pubmed_data2)

# Remove rows with NA values
pubmed_data2 <- pubmed_data2[(!pubmed_data2$Abstract == "NA"),]
str(pubmed_data2)

# Convert to character (not needed here but a good check anyway)
pubmed_data2 <- as.character(pubmed_data2)
str(pubmed_data2)

### 4. Create corpus
## We cannot install multiple packages in one function call as shown in the lecture notes

install.packages("tm")
install.packages("ggplot2")
install.packages("wordcloud")
install.packages("SnowballC")
library(tm)
library(ggplot2)
library(wordcloud)
library(SnowballC)

corpus_pubmed_data2 <- Corpus(VectorSource(pubmed_data2))
print(corpus_pubmed_data2 [1:2])
inspect(corpus_pubmed_data2[1:3])

## 5. Clean the corpus / Preprocessing
# The code in the lecture is very segmented, likely to show what each function does.
# Notice that there are other modifications to the unstemmed corpus that are made after stemming,
# which to me suggests a workflow problem since we're using the stemmed data for forward analysis.

opioid <- tm_map(corpus_pubmed_data2, 
                 removePunctuation) ### punction is tokenized
inspect(opioid[1])

opioid <- tm_map(opioid, removeNumbers)
inspect(opioid[1])

opioid <- tm_map(opioid, tolower)
inspect(opioid[1])

opioid_stem <- tm_map(opioid, stemDocument) #similar words converted to one word
inspect(opioid[1])

opioid <- tm_map(opioid, removeWords, stopwords("SMART"))
inspect(opioid[1])

opioid <- tm_map(opioid, stripWhitespace)
inspect(opioid[1])

# Tokenization
dtm <- DocumentTermMatrix(opioid_stem)

## 6. TM analysis
# Term frequency analysis
findFreqTerms(dtm, lowfreq = 5)
findFreqTerms(dtm, lowfreq = 50) ### this is the best place to remove additional words

# Term document matrix (TDM)
# The original code here was incorrect, as minWordLength isn't a range but a value
# I've corrected the code here to reflect that
tdm <- TermDocumentMatrix(opioid, control = list(minWordLength=1))
inspect(tdm)

# Term frequency & visualization
termFrequency <- rowSums(as.matrix(tdm))
termFrequency <- subset(termFrequency, termFrequency>=50)
head(termFrequency)
barplot(termFrequency, las=2,col=rainbow(10), xlab = "count", ylab="word")

## 7. Wordcloud
# This section covers various visualization parameters in the wordcloud package function
# Convert TDM to matrix
m <- as.matrix(tdm)

# Set seed for reproducibility
set.seed(375)

# Compute word frequencies
wordFreq <- sort(rowSums(m), decreasing = TRUE)

# Basic word cloud
# I adjusted this to prevent warnings from overcrowding by adding a max.words parameter
wordcloud(words = names(wordFreq), freq = wordFreq, min.freq = 30, 
          max.words = 100, random.order = FALSE)

# Word cloud with rainbow colors (less readable)
# Same 100 word limit
wordcloud(words = names(wordFreq), freq = wordFreq, min.freq = 30,  
          max.words = 100, random.order = FALSE, colors = rainbow(20))

# Word cloud with better colors (Dark2 palette)
# Same 100 word limit
wordcloud(words = names(wordFreq), freq = wordFreq, min.freq = 30,  
          max.words = 100, random.order = FALSE, colors = brewer.pal(6, "Dark2"))

# Word cloud with controlled word size scaling
# Same 100 word limit
wordcloud(words = names(wordFreq), scale = c(5, 0.2), freq = wordFreq, min.freq = 30,  
          max.words = 100, random.order = FALSE, colors = brewer.pal(6, "Dark2"))

# Word cloud with word rotation and max word limit
wordcloud(words = names(wordFreq), rot.per = 0.2, scale = c(5, 0.2), freq = wordFreq, 
          max.words = 30, random.order = FALSE, colors = brewer.pal(6, "Dark2"))




                        
