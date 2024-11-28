###########################################
###########################################
#
# This the file with the function that download the data
#
############################################
############################################

##### libraries ############################
library(here)

# Set path
setwd(here())
setwd('data')


# get_enron_data: download the enron data from the url to specified folder
# Input:
# - data_path: The url of the data, prespecified but left open in case it changes
# Output:
# - None

get_enron_data = function(data_path = 'http://www.cs.cmu.edu/~enron/enron_mail_20150507.tar.gz', 
                    folder_path = 'enron_mail_20150507.tar.gz'){
  
  #set high timeout as data is large
  options(timeout = 1e6)
  cat('Please be patient, this can take a while.\n Downloading...')
  download.file(data_path, folder_path)
  print('Downloaded.')
  print('decompressing...')
  untar(data_path, exdir = 'enron_mail_20150507')
  #decompresed('Done.')
  #file.remove(data_path)
}

# get_word2vec: download the Google News Negative 300 binary file for word2vec
# Input:
# - data_url: url where the file can be downloaded
# - data_path: file name after downloaded
# Output:
# - None

get_word2vec = function(data_url = 'https://huggingface.co/NathaNn1111/word2vec-google-news-negative-300-bin/resolve/main/GoogleNews-vectors-negative300.bin?download=true', 
                          data_path = 'GoogleNews-vectors-negative300.bin'){
  
  #set high timeout as data is large
  options(timeout = 1e6)
  cat('Please be patient, this can take a while.\n Downloading wor2vec encoding...')
  download.file(data_url, data_path)
  print('Downloaded.')
}


get_enron_data()
