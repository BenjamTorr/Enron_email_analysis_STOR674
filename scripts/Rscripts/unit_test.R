# Unit test for functions in data_utils.R

# Set path
setwd(here())

# Source data_utils.R
source("./scripts/Rscripts/data_utils.R")

#### Unit test for parse_email#####

test_that("parse_email() works", {
  res = parse_email('./data/enron_mail_20150507/maildir/allen-p/_sent_mail/1.')
  solution = data.frame(User = c('allen-p'), Folder = c('_sent_mail'), 
                        Sender = c('phillip.allen@enron.com'), Receiver = c('tim.belden@enron.com'),
                        Subject = c(''), Content = 'Here is our forecast')
  expect_true(all(res == solution))
})


#### Unit test for parse_all_email#####

test_that("parse_all_email() works", {
  file_paths = c("./data/enron_mail_20150507/maildir/allen-p/_sent_mail/1.", "./data/enron_mail_20150507/maildir/allen-p/_sent_mail/10.")
  res = parse_all_emails(file_paths)
  solution = data.frame(User = c('allen-p', 'allen-p'), Folder = c('_sent_mail','_sent_mail'), 
                        Sender = c('phillip.allen@enron.com', 'phillip.allen@enron.com'), Receiver = c('tim.belden@enron.com', 'john.lavorato@enron.com'),
                        Subject = c('','Re:'), Content = c('Here is our forecast',"Traveling to have a business meeting takes the fun out of the trip. Especially if you have to prepare a presentation. I would suggest holding the business plan meetings here then take a trip without any formal business meetings. I would even try and get some honest opinions on whether a trip is even desired or necessary. As far as the business meetings, I think it would be more productive to try and stimulate discussions across the different groups about what is working and what is not. Too often the presenter speaks and the others are quiet just waiting for their turn. The meetings might be better if held in a round table discussion format. My suggestion for where to go is Austin. Play golf and rent a ski boat and jet ski's. Flying somewhere takes too much time."))
  expect_true(all(res == solution))
})


#### Unit test for parse_all_email#####

test_that("parse_all_email() works", {
  email_data = parse_all_emails(c('./data/enron_mail_20150507/maildir/dickson-s/sent/9.'))
  res = split_receivers(email_data)
  expect_true(nrow(res) == 2)
})



#### Unit test for get_active_users #####

test_that("get_active_users() works", {
  df_from = data.frame(item="alberto.gude@enron.com", frequency = 6)
  df_to = data.frame(item = "alberto.gude@enron.com", frequency = 6)
  all_users = as.array("alberto.gude@enron.com")
  res = get_active_users(df_from=df_from, df_to=df_to, all_users=all_users, threshold=1)
  expect_true(length(res) == 1)
})



