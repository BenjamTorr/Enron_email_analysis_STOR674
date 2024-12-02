#################################
## In this file we execute the analysis using kip-gram analysis to cluster the top users
##
###
#################################


#load libraries
library(ggplot2)
library(word2vec)


# Set work directory
library(here)
setwd(here())
set.seed(123)
# Source the functions
source("./scripts/Rscripts/data_utils.R")
source("./scripts/Rscripts/analysis_utils.R")


# Load data
load("./data/cleaned_email_data.RData")

#---------------------- Clustering Analysis ------------------------------------#
set.seed(123) #set seed for reproducibility

#get emedding using dimension 3 and only considering users that sent and received at least 500
analysis = get_user_embedding(email_data, 3, 500)
embeddings = analysis$embeddings #extract embedding
interaction_embedding = analysis$interaction_embedding #extract data frame with sender and receiver + embedding
interaction_embedding$cluster = kmeans(embeddings[,1:3], centers = 4, nstart = 25)$cluster[interaction_embedding$sender] #cluster users

#---------------------- Plotting results ---------------------------------------#
#set colors for clusters
custom_colors <- c("1" = "red",
                   "2" = "blue",
                   "3" = "green",
                   "4" = "purple")


plot1 = ggplot() +
        # Plot the sender points
        geom_point(data = interaction_embedding, aes(x = X1.x, y = X2.x), color = "black", size = 2) +
        theme_minimal() +
        labs(title = "Interaction Embeddings by Cluster",
          color = "Cluster")

plot1

ggsave(filename = 'Images/top_users_embedding.png', plot = plot1, dpi = 300)

plot2 = ggplot() +
        # Plot the sender points
        geom_point(data = interaction_embedding, aes(x = X1.x, y = X2.x), color = "black", size = 2) +
        # Plot lines between sender and receiver
        geom_segment(data = interaction_embedding, aes(x = X1.x, y = X2.x, xend = X1.y, yend = X2.y),
                     color = 'black', size = 0.1) +
        theme_minimal() +
        labs(title = 'Interaction between top users within embedding')

plot2

ggsave(filename = 'Images/top_users_embedding_plus_interaction.png', plot = plot2, dpi = 300)


plot3 = ggplot() +
        # Plot the sender points
        geom_point(data = interaction_embedding, aes(x = X1.x, y = X2.x), color = "black", size = 2) +
        # Plot lines between sender and receiver
        geom_segment(data = interaction_embedding, aes(x = X1.x, y = X2.x, xend = X1.y, yend = X2.y, color = as.factor(cluster)),
                    size = 0.1) +
        theme_minimal() +
        scale_color_manual(values = custom_colors) +
        labs(title = 'Interaction between top users within embedding clustered', color = "Cluster")

plot3

ggsave(filename = 'Images/top_users_embedding_plus_interaction_clustered.png', plot = plot3, dpi = 300)
