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


## Try the classification on one person's folders
# Set seed for reproduction
set.seed(123)

# Set the example user_name and get the number of emails in this person's folder
user_name <- "smith-m"
paste("The number of emails in the user's folder: ", length(which(email_data$User==user_name)))

# Do folder classification
conf_mat <- folder_classification(model,email_data,user_name, ntree = floor(0.7*length(which(email_data$User==user_name))))

# Extract the prediction table
cm_df <- conf_mat$table


library(ggplot2)

png("word2vec_rf_classification.png") 
# Create the plot
ggplot(data = as.data.frame(cm_df), aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile(color = "black") +  # Create heatmap
  geom_text(aes(label = Freq), color = "black", size = 5) +  # Add numbers
  scale_fill_gradient(low = "white", high = "blue") +  # Adjust color scale
  labs(title = "The prediction result of smith-m's emails", x = "Predicted", y = "Actual") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()
