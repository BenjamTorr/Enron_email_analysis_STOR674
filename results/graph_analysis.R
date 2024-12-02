### we visualize the interaction between active users in the company. 
## Note that the isolate nodes indicate they only interact with inactive users or themselves.

# Set work directory
library(here)
setwd(here())

# Load data
load("./data/cleaned_email_data.RData")

# Source the functions
source("./scripts/Rscripts/data_utils.R")

## Get edges between users
edges = NULL
u=0
for (i in 1:dim(email_data)[1]){
  if(u==1){
    break
  }
  index_from_users <- which(active_users == email_data$Sender[i])
  to_list <- split_receivers(email_data[i,])$Receiver
  if ((length(to_list) >0) & (length(index_from_users) > 0)){
    for (j in 1:length(to_list)){
      index_to_users <- which(active_users == to_list[j])
      if(length(index_to_users) > 0){
        edges <- c(edges, index_from_users, index_to_users)
      }
      if(length(edges) %% 2 == 1){
        print(i)
        u=1
        break
      }
    }
  }
}

# Use igraph to do the visualization
library("igraph")
g <- make_graph(edges,  n=length(active_users), directed = FALSE)
par(mar = c(1,1,1,1))
png("Images/interaction_of_active_users.png") 
plot(g, vertex.size = 5, vertex.label = NA, edge.width=0.1, asp=0.9)
dev.off()
