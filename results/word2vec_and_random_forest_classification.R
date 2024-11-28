# We consider using a pretrained word2vec model 
## to do email folder prediction for each person

# Load the pretrained word2vec model
library(word2vec)



# Source analysis_utils.R
library(here)
setwd(here())

word2vec_path = './data/GoogleNews-vectors-negative300.bin'

if (!file.exists(word2vec_path)){
  source('./scripts/Rscripts/data_download.R')
}

model     <- read.word2vec(word2vec_path)
#embedding <- as.matrix(model)

# Load data
load("./data/cleaned_email_data.RData")
source("./scripts/Rscripts/analysis_utils.R")


# Try the classification on one person's folders
# Set seed for reproduction
set.seed(123)
user_name <- "allen-p"
folder_classification(model,email_data,user_name)
