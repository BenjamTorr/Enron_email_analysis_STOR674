library(caret)
library(randomForest)
library(word2vec)


# folder_classification: Define a function to classify the emails for each person based on their folders
# Input:
# - model: a pretrained word2vec model
# - email_data: the cleaned email data with all the information for each email
# - user_name: a person's username (foldername) that we want to classify 
# Output:
# - the outcome of random forest classification on trained and test data

folder_classification <- function(model, email_data, user_name){
  # Extract data information of this person
  email_person_data <- email_data[which(email_data$User==user_name),]
  email_person_labels <- email_data$Folder[which(email_data$User==user_name)]
  
  # Get rid of the folders with less emails
  labels <- levels(factor(email_person_labels))
  for (i in 1:length(labels)){
    if (length(which(email_person_labels==labels[i]))<50){
      email_person_data <- email_person_data[-which(email_person_data$Folder == labels[i]),] 
    }
  }
  
  # Get rid of all_documents folder as there is no clear pattern inside
  email_person_data <- email_person_data[-which(email_person_data$Folder == "all_documents"),]
  
  # Merge the folders of sent and merge the folders of inbox
  subset_sent <- grep("sent", email_person_data$Folder, ignore.case = TRUE)
  if (length(subset_sent) > 0){
    email_person_data[subset_sent,]$Folder <- "sent"
  }
  subset_inbox <- grep("inbox", email_person_data$Folder, ignore.case = TRUE)
  if (length(subset_inbox) > 0){
    email_person_data[subset_inbox,]$Folder <- "inbox"
  }
  
  # Transform the folder name to factors and use them as labels
  email_person_labels <- factor(email_person_data$Folder)
  
  n <- length(email_person_labels)
  email_person_data$Content <- tolower(email_person_data$Content)
  
  # For each email, do embedding for each word and take the average as the embedding of this email
  email_person_embbedding <- matrix(0,n,model$dim)
  for (i in 1:n){
    words <- str_extract_all(email_person_data$Content[i], "\\b\\w+\\b")[[1]]
    words_embeddings <- predict(model, newdata = words, type = "embedding")
    words_embeddings[is.na(words_embeddings)] <- 0
    if(sum(is.na(words_embeddings))>0){
      break
    }
    if(!is.null(dim(words_embeddings))){
      email_person_embbedding[i,] <- colMeans(words_embeddings)
    }else{
      email_person_embbedding[i,] <- words_embeddings
    }
  }
  
  
  
  
  n_sample = length(email_person_labels)
  
  # Split train and test sets
  trainIndex <- createDataPartition(email_person_labels, p = 0.8, list = FALSE)
  train_data <- email_person_embbedding[trainIndex,]
  train_labels <- email_person_labels[trainIndex]
  test_data <- email_person_embbedding[-trainIndex, ]
  test_labels <- email_person_labels[-trainIndex]
  
  # Train a Random Forest classifier
  model_rf <- randomForest(x = train_data, y = train_labels)
  
  # Print model summary
  print(model_rf)
  
  # Predict on test data
  predictions <- predict(model_rf, test_data)
  
  # Evaluate model performance
  conf_matrix <- confusionMatrix(predictions, test_labels)
  print(conf_matrix)
  
}

# get_user_embedding: a function that takes the email data, and transform the names into an embedding using NLP technques
# Input:
# - email_data: the cleaned dataset
# - dimension: the dimension for the embedding
# - threshold: the threshold to eliminate inactive users
# Output:
# - embeddings: a dataframe with the embeddings per user
# - interaction_embedding: dataframe with sender -> receiver plus the embedding of the sender and embedding of receiver


get_user_embedding = function(email_data, dimension, threshold){
  active_interactions = clean_sender_receiver(email_data, threshold)
  sentences = active_interactions$user_context
  model = word2vec(x = sentences, dim = dimension, type = c('cbow'), stopwords = NULL)
  embeddings = data.frame(as.matrix(model))
  embeddings$sender = row.names(embeddings)
  interaction_embedding_sender = merge(active_interactions, embeddings, by.x = 'sender', by.y = 'sender')
  interaction_embedding = merge(interaction_embedding_sender, embeddings, by.x = 'receiver', by.y ='sender')
  
  return(list(embeddings = embeddings, interaction_embedding = interaction_embedding))
  
}