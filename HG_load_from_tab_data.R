# date        2023-08-20
# project     
# R Version   4.2.1 (2022-06-23 ucrt)
# R packages  /

# loads one data set and selects meta data from from .tab file
# -------------------------------------------------------------------------------

# seperation of .tab file
raw_file_path = paste0(dir_name_archive, "/", dataset_file)

# load data
raw_data = readLines(raw_file_path);


# separate data table from meta data --------------------
# assumption: meta data is enclosed by /* and */
ind_meta_start = grep(raw_data, pattern = '/\\*')
ind_meta_end   = grep(raw_data, pattern = '\\*/')

# lines containing meta data
current_meta_data = raw_data[ind_meta_start:ind_meta_end]

#read.csv(text = current_meta_data, sep = '\t', row.names = NULL)

# data table sep = '\t'
only_data = read.csv(raw_file_path, skip = ind_meta_end, sep = '\t', check.names = F)

# get some meta data -----------------------------------

# find citation - all names correct?
ind_citation     = grep(current_meta_data, pattern = 'citation', ignore.case = T)

if(length(ind_citation) > 0){
  current_citation = current_meta_data[ind_citation]

  # read after tab-seperator
  ind_citation     = gregexpr(pattern = "\t", text = current_citation)[[1]][1]+1
  current_citation = substr(x = current_citation, 
                          start = ind_citation, stop = nchar(current_citation))

  dataset_citation = current_citation
}
