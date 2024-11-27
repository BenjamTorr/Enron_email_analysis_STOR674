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
  print('Downloading...')
  download.file(data_path, folder_path)
  print('Downloaded.')
  print('decompressing...')
  untar(data_path, exdir = 'enron_mail_20150507')
  decompresed('Done.')
  file.remove(data_path)
}