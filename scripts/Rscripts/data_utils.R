###########################################
###########################################
#
# This script compacts define the functions
# needed for the extraction of the raw data
# for further analysis
#
############################################
############################################

##### libraries ############################

library(tidyverse)
library(testthat)
library(assertthat)
library(here)

# Set path
setwd(here())

###### Functions ############################
#############################################
#############################################

#---------------------------------------------------

# parse_email: Define a function to parse a single email
# Input:
# - file_path: The file path for the email we want to parse
# Output:
# - dataframe: a dataframe with the following columns
#       - user: email handle of the user that sent the email
#       - Folder: Folder that this email belongs to
#       - Sender: Email of the sender
#       - Receiver: Email of the receiver
#       - Subject: Subject of the email
#       - Content: Message of the email

parse_email <- function(file_path) {
  # Read the email content
  email_content <- readLines(file_path, warn = FALSE)
  
  # Extract header information
  from <- str_extract(email_content[grep("^From:", email_content)], "(?<=From: ).*")
  to <- str_extract(email_content[grep("^To:", email_content)], "(?<=To: ).*")
  subject <- str_extract(email_content[grep("^Subject:", email_content)], "(?<=Subject: ).*")
  
  # Find the body of the email (after the first empty line)
  body_start <- which(email_content == "")[1] + 1
  body <- paste(email_content[body_start:length(email_content)], collapse = "\n")
  
  # Clean up the body by removing excessive newlines
  body_cleaned <- str_replace_all(body, "\\s*\\n\\s*", " ") # Replace newlines with a single space
  body_cleaned <- str_squish(body_cleaned) # Remove leading/trailing whitespace
  
  folder <- basename(dirname(file_path))
  user <- basename(dirname(dirname(file_path)))
  
  # Return a structured data frame
  return(data.frame(
    User = user,
    Folder = folder,
    Sender = ifelse(is.null(from), NA, from),
    Receiver = ifelse(is.null(to), NA, to),
    Subject = ifelse(is.null(subject), NA, subject),
    Content = ifelse(is.null(body_cleaned), NA, body_cleaned),
    stringsAsFactors = FALSE
  ))
}

# ------------------------------------------------------------------

# parse_all_emails: Define a function to get all of the emails
# Input:
# - file_paths: An array containing all the file paths for the email we want to parse
# Output:
# - dataframe: a dataframe with one row per email and the following columns
#       - user: email handle of the user that sent the email
#       - Folder: Folder that this email belongs to
#       - Sender: Email of the sender
#       - Receiver: Email of the receiver
#       - Subject: Subject of the email
#       - Content: Message of the email

parse_all_emails = function(file_paths){
  return(bind_rows(lapply(file_paths, parse_email)))
}


#------------------------------------------------------------------

# split_receivers: take a dataframe with user information an return a dataframe with one row per receiver
# Input:
# - email_data: An array containing all the file paths for the email we want to parse
# Output:
# - dataframe: a dataframe with one row receiver in each email and the following columns
#       - user: email handle of the user that sent the email
#       - Folder: Folder that this email belongs to
#       - Sender: Email of the sender
#       - Receiver: Email of the receiver
#       - Subject: Subject of the email
#       - Content: Message of the email

split_receivers <- function(email_data) {
  email_data %>%
    separate_rows(Receiver, sep = "\\s*,\\s*|\\s*;\\s*|\\s+") %>% # Split by commas, semicolons, or spaces
    mutate(
      # Extract email addresses from various formats
      Receiver = str_extract(Receiver, "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"),
      
      # Remove empty entries that result from unmatched patterns
      Receiver = ifelse(is.na(Receiver), "", Receiver)
    ) %>%
    filter(Receiver != "") # Remove rows with empty Receiver fields
}


#---------------------------------------------------


# get_active_users: Define a function to remove inactive users from all users
# Input:
# - df_from: a data frame with the number of emails sent by each user
# - df_to: a data frame with the number of emails received by each user
# - all_users: an array of characters with all users in the company
# - threshold: the threshold that identifies active users
# Output:
# - array: an array of characters that contains the email addresses for active users

get_active_users <- function(df_from, df_to, all_users, threshold){
  n <- length(all_users)
  active_users <- NULL
  for (i in 1:n){
    if (length(which(df_from == all_users[i])) > 0){
      if (length(which(df_to == all_users[i])) > 0){
        if ((df_from[which(df_from == all_users[i]),][2] > threshold) & (df_to[which(df_to == all_users[i]),][2] > threshold)){
          active_users <- c(active_users, all_users[i]) # keep active users that sent more than threshold emails and received more than threshold emails
        }
      }
    }
  }
  return(active_users)
}


