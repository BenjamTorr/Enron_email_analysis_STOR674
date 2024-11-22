rm(list=ls())

# 
setwd("/Users/yangxiang/Documents/FinalProject674")
emails.all.files <- list.files("./maildir/", full.names = T, recursive = T)
paste("The number of emails in this dataset: ", length(emails.all.files))


# Load the 
email_data <- read.csv("/Users/yangxiang/Documents/FinalProject674/parsed_emails.csv")


# Define a function to split multiple receivers into separate rows
split_receivers <- function(email_data) {
  email_data %>%
    separate_rows(Receiver, sep = "\\s*,\\s*|\\s*;\\s*|\\s+") %>% # Split by commas, semicolons, or spaces
    filter(Receiver != "") # Remove empty rows (in case of blank fields)
}


email_data$Sender

# Extract all the user emails inside enron
sender_enron <- email_data$Sender[grepl("@enron.com", email_data$Sender)]
receiver <- split_receivers(email_data)$Receiver
receiver_enron <- receiver[grepl("@enron.com", receiver)]

# The number of unique users in the company
paste("The number of unique users in the company", nrow(data.frame(item = c(sender_enron,receiver_enron)) %>%
       count(item, name = "frequency")))

# Plot figures to show the total number of emails sending and receiving by each employee in this company. 
df_from <- data.frame(item = sender_enron) %>%
  count(item, name = "frequency")
ggplot(df_from, aes(x = frequency)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Histogram of Item Frequencies", x = "Number of Sent Emails", y = "Count") +
  theme_minimal()


df_to <- data.frame(item = receiver_enron) %>%
  count(item, name = "frequency")
ggplot(df_to, aes(x = frequency)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Histogram of Item Frequencies", x = "Number of Received Emails", y = "Count") +
  theme_minimal()


# show top 10 people who sent the most emails
df_from[order(df_from[,2],decreasing = TRUE)[1:10],]
# show top 10 people who got the most emails
df_to[order(df_to[,2],decreasing = TRUE)[1:10],]


# All users in the company
all_users <- data.frame(item = c(sender_enron, receiver_enron)) %>%
  count(item, name = "frequency")
all_users <- all_users[,1]


# Remove inactive users (keep users that at least send 2 emails and receive 2 emails)
n <- length(all_users)
active_users <- NULL
for (i in 1:n){
  if (length(which(df_from == all_users[i])) > 0){
    if (length(which(df_to == all_users[i])) > 0){
      if ((df_from[which(df_from == all_users[i]),][2] > 1) & (df_to[which(df_to == all_users[i]),][2] > 1)){
        active_users <- c(active_users, all_users[i])
      }
      
    }
  }
}

paste("The number of active users in the company", length(active_users))


# Get edges between users
edges = NULL
u=0

