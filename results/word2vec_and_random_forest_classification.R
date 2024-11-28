# We consider using a pretrained word2vec model 
## to do email folder prediction for each person

# Load the pretrained word2vec model
library(word2vec)
model     <- read.word2vec("/Users/yangxiang/Documents/FinalProject674/GoogleNews-vectors-negative300.bin")
#embedding <- as.matrix(model)

# Load data
load("./data/cleaned_email_data.RData")

# Source analysis_utils.R
library(here)
setwd(here())
source("./scripts/Rscripts/analysis_utils.R")


# Try the classification on one person's folders
# Set seed for reproduction
set.seed(123)
user_name <- "allen-p"
folder_classification(model,email_data,user_name)
