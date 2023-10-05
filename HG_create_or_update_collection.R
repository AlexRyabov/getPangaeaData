# date        2023-10-05
# project     
# R Version   4.2.1 (2022-06-23 ucrt)
# R packages  /

# main file: create initial file collection from list or update main collection 
# (one dataset)
# -------------------------------------------------------------------------------

rm(list = ls())

# LOAD ONE DATA SET?
add_one_dataset = FALSE # set to FALSE -> infos from variable_names_in_datasets.xlsx 
                        # and dataset_links.xlsx are used

sep_for_main_data = "\t"
max_depth = 120         # only data with depth above -120m will be used

if (add_one_dataset){
  
  # SPECIFICATIONS ----------------------------------------------------------------
  
  current_ID   = "855799" # str, must allways be specified!
  
  from_ID      = FALSE    # bool, loads from ID + with pangear
  from_tab_data= TRUE     # bool, loads from .tab data downloaded from pangaea website
  
  dataset_file = "ARK-XXIV_2_chl-a.tab" # should be in raw_data/archive; must be 
                                        # specified if from_tab_data == TRUE
  
  #data_collection = ""  # name of collection, "CTD", "Chlorophyll", "nutrients" "<custom>"
  #alias_var_names = ""  # names of variable in main collection file
  #data_var_names  = ""  # names of varoables in dataset (set to NA if a variable does 
                        # not exist in dataset)
  
  # some meta data
  dataset_url = ""
  dataset_citation = ""
  
  # EXAMPLE 
  data_collection = "Chlorophyll"
  alias_var_names = c("event",
                      "date_time",
                      "long",
                      "lat",
                      "elevation",
                      "depth",
                      "temp",
                      "chlorophyll_a_0",
                      "chlorophyll_b_0",
                      "chlorophyll_c3_0",
                      "chlorophyllide_a_0",
                      "chlorophyllide_b_0")

  data_var_names = c("Event",
                     "Date/Time",
                     "Longitude",
                     "Latitude",
                     "Elevation [m]",
                     "Depth water [m]",
                     NA,
                     "Chl a [µg/l]",
                     NA,
                     NA,
                     NA,
                     NA)
  
  # EXAMPLE
  #data_collection = "CTD"
  #data_var_names = c(NA,
  #                   "Date/Time",
  #                   "Longitude", 
  #                   "Latitude",
  #                   NA,
  #                   "Depth water [m]", 
  #                   "Temp [°C]", 
  #                   "Cond [mS/cm]",
  #                   "Sal")
  
  update_main_file = TRUE
  
  source("HG_add_one_dataset.R")
  
# ---------------------------------------------------------------------------------
  
} else {
  
  # specifications
  update_main_file = TRUE
  
  from_ID       = TRUE
  from_tab_data = FALSE
  
  # use the table for getting all data sets
  # necessary IDs
  ID_list = readxl::read_xlsx("dataset_links.xlsx")
  
  # IDs and the variable names per dataset for each alias (variable in main file)
  vars_per_ID = readxl::read_xlsx("variable_names_in_datasets.xlsx")
  
  for (i in 1:length(ID_list$ID)){
    
    # check whether an ID exists
    if (!is.na(ID_list$ID[i])){
      
      current_ID = ID_list$ID[i]
      data_collection = ID_list$data_collection[i]
      
      dataset_file = ""
      
      # some meta data
      dataset_url = ID_list$url[i]
      dataset_citation = ID_list$citation[i]
      
      # get var names and alias names from table per ID
      # indices for current ID and collection
      ind = vars_per_ID$ID == current_ID & vars_per_ID$data_collection == data_collection
      
      current_vars_per_ID = vars_per_ID[ind, ]
      
      # to get correct order of variables
      ind_sort = sort(current_vars_per_ID$column, index.return = T)$ix
      
      data_var_names = current_vars_per_ID$data_var_names[ind_sort]
      alias_var_names = current_vars_per_ID$alias_var_names[ind_sort]
      
      source("HG_add_one_dataset.R")
      
    }
  }
}

