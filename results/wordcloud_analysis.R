# This is a wordcloud analysis for all email content

library(tm)
library(wordcloud)
library(RColorBrewer)
library(here)

setwd(here())
load("./data/cleaned_email_data.RData")

# Convert all the email content to a huge character
text <- paste(email_data$Content, collapse = " ")
corpus <- Corpus(VectorSource(text))

# Preprocess the text
corpus <- tm_map(corpus, content_transformer(tolower))           # Convert to lowercase
corpus <- tm_map(corpus, removePunctuation)                      # Remove punctuation
corpus <- tm_map(corpus, removeNumbers)                          # Remove numbers
corpus <- tm_map(corpus, removeWords, stopwords("english"))      # Remove stopwords
corpus <- tm_map(corpus, stripWhitespace)                        # Remove extra spaces


# Convert to a Term-Document Matrix
tdm <- TermDocumentMatrix(corpus)

# Convert to a matrix and get word frequencies
matrix <- as.matrix(tdm)
word_freq <- sort(rowSums(matrix), decreasing = TRUE)

# Generate the word cloud
set.seed(1234)  # For reproducibility
wordcloud(
  names(word_freq), 
  freq = word_freq, 
  min.freq = 2,                     # Adjust based on your data
  max.words = 200,                  # Maximum number of words
  random.order = FALSE,             # High-frequency words in the center
  colors = brewer.pal(8, "Dark2")   # Color palette
)

png("Images/wordcloud_high_res.png", width = 10, height = 10, units = "in", res = 300)  # 300 DPI
wordcloud(names(word_freq), freq = word_freq, min.freq = 2, max.words = 200, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
dev.off()

