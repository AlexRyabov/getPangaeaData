# date        2023-08-20
# project     
# R Version   4.2.1 (2022-06-23 ucrt)
# R packages  /

# loads one data set and selects meta data from ID with R-library pangear
# -------------------------------------------------------------------------------

# load necessary package
library(pangaear)

# load functions
source("HG_dataimport_functions.R")

# for pangaear-function 
current_doi = paste0("10.1594/PANGAEA.", current_ID)    # format of doi

# try loading dataset
x = tryCatch(pg_data(current_doi), error = function(e)e)

# if dataset cannot be loaded
if(inherits(x, "error")){
  
  # save the ID in meta_data_file with the information that it did not work!
  meta_data$loaded[ind_ID] = 0
  print(paste0("loading from pangaea did not work for ID = ", current_ID))
  
} else {
  
  # adjust meta data
  meta_data$loaded[ind_ID] = 1
  
  # when download is possible
  current_data = pg_data(current_doi)
  
  # number of child data sets in parent data set
  n_datasets = length(current_data)
  meta_data$n_child_data[ind_ID] = n_datasets
  
  if (n_datasets > 1){
    
    print("is dataset collection, use ID of child dataset.")
    
  } else {
    
    # save the data set with ID (parent-ID if parent-dataset)
    nam_r_data = paste0(dir_name_archive, '/ID_', current_ID, '.rds')
    
  }
  
  # file path for adding to meta data
  raw_file_path = nam_r_data
  
  # raw data is saved as R-specific file format (contains meta data)
  saveRDS(current_data, file = nam_r_data)
  
} # end of data loading 
  
  
# loading of raw data done --------------------------------------------

# get the data tables from RDS-object
if (n_datasets == 1){
  
  only_data = current_data[[1]]$data
  
  # save the link
  dataset_url = current_data[[1]]$url
  
  
  # saving the variable description
  if (length(current_data[[1]]$metadata) > 1){
    
    # save the citation 
    if (length(current_data[[1]]$metadata$citation) > 0){
      dataset_citation = current_data[[1]]$metadata$citation
    }
    
    # save coverage for coordinates and date time if not variable
    if (length(current_data[[1]]$metadata$coverage) > 0){
      meta_data$coverage[ind_ID] = current_data[[1]]$metadata$coverage
    }
    
    n_var = length(current_data[[1]]$metadata$parameters)
    
    for (i_var in 1:n_var){
      
      # pasting all variable descriptions 
      meta_data$descriptions[ind_ID] = paste0(
        meta_data$descriptions[ind_ID], ';-;', 
        current_data[[1]]$metadata$parameters[[i_var]][1])
    }
  }
}

# removing variables 
rm(list = c("n_var", "n_datasets", 
            "current_doi", "nam_r_data"))


  