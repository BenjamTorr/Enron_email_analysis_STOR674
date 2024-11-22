rm(list=ls())
library(tidyverse)

#Retrieval all files in the maildir
setwd("/Users/yangxiang/Documents/FinalProject674")
emails.all.files <- list.files("./maildir/", full.names = T, recursive = T)

# Define a function to parse a single email
# Load necessary libraries
library(tidyverse)

# Define a function to parse a single email
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

# Parse all the emails

email_data <- bind_rows(lapply(emails.all.files, parse_email))
head(email_data)

# Print the parsed email

write.csv(email_data, "/Users/yangxiang/Documents/FinalProject674/parsed_emails.csv", row.names = FALSE)
