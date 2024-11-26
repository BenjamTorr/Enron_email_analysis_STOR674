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


#### Unit test #####

test_that("parse_email() works", {
  res = parse_email('./maildir/allen-p/_sent_mail/1.')
  solution = data.frame(User = c('allen-p'), Folder = c('_sent_mail'), 
                        Sender = c('phillip.allen@enron.com'), Receiver = c('tim.belden@enron.com'),
                        Subject = c(''), Content = 'Here is our forecast')
  expect_true(all(res == solution))
})

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


#### Unit test #####

test_that("parse_all_email() works", {
  file_paths = c("./maildir/allen-p/_sent_mail/1.", "./maildir/allen-p/_sent_mail/10.")
  res = parse_all_emails(file_paths)
  solution = data.frame(User = c('allen-p', 'allen-p'), Folder = c('_sent_mail','_sent_mail'), 
                        Sender = c('phillip.allen@enron.com', 'phillip.allen@enron.com'), Receiver = c('tim.belden@enron.com', 'john.lavorato@enron.com'),
                        Subject = c('','Re:'), Content = c('Here is our forecast',"Traveling to have a business meeting takes the fun out of the trip. Especially if you have to prepare a presentation. I would suggest holding the business plan meetings here then take a trip without any formal business meetings. I would even try and get some honest opinions on whether a trip is even desired or necessary. As far as the business meetings, I think it would be more productive to try and stimulate discussions across the different groups about what is working and what is not. Too often the presenter speaks and the others are quiet just waiting for their turn. The meetings might be better if held in a round table discussion format. My suggestion for where to go is Austin. Play golf and rent a ski boat and jet ski's. Flying somewhere takes too much time."))
  expect_true(all(res == solution))
})

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
      Receiver = str_remove_all(Receiver, "^['\"\\.<]+|['\"\\.>]$"), # Remove leading/trailing quotes, periods, <, >
      Receiver = str_replace_all(Receiver, '""', "")                # Remove double quotes anywhere in the string
    ) %>%
    filter(Receiver != "") # Remove empty rows (in case of blank fields)
}

#### Unit test #####

test_that("parse_all_email() works", {
  email_data = parse_all_emails(c('./maildir/dickson-s/sent/9.'))
  res = split_receivers(email_data)
  expect_true(nrow(res) == 2)
})


#---------------------------------------------------


# remove inactive users: Define a function to remove inactive users from all users
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


#### Unit test #####

test_that("get_active_users() works", {
  df_from = data.frame(item="alberto.gude@enron.com", frequency = 6)
  df_to = data.frame(item = "alberto.gude@enron.com", frequency = 6)
  all_users = as.array("alberto.gude@enron.com")
  res = get_active_users(df_from=df_from, df_to=df_to, all_users=all_users, threshold=1)
  expect_true(length(res) > 0)
})

