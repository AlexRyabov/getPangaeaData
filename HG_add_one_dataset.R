# date        2023-10-05
# project     
# R Version   4.2.1 (2022-06-23 ucrt)
# R packages  /

# get data and metadata, updates main collection file 
# -------------------------------------------------------------------------------

source("HG_dataimport_functions.R")

# set alias and/or check whether variables and alias elements are equal in number

if (length(data_var_names) == length(alias_var_names)){
    
    print(paste0('Variables in current dataset ', 
                 current_ID, ' and alias in main collection file: ')); print("")
    print(cbind(data_var_names, alias_var_names))
  
  } else {
  
    print('Number of elements differs in alias_var_names and data_var_names.')
}


# for saving raw data
dir_name_raw          = "raw_data"
dir_name_archive      = "raw_data/archive"

# for main data
dir_name_export     = "selected_data_collection"
dir_name_collection = paste0(dir_name_export, "/data_selected_", data_collection)

# for meta data file
file_name_meta_data = paste0(dir_name_export, "/meta_data_main_", data_collection, ".csv")

# NECESSARY DIRECTORIES AND FILES ------------------------------------
if (!dir.exists(dir_name_export)){
  dir.create(dir_name_export)}     # folder for all data collections

if (!dir.exists(dir_name_collection)){
  dir.create(dir_name_collection)} # folder for one data collection eg. CTD 

if (!dir.exists(paste0(dir_name_collection, "/main_data"))){
  dir.create(paste0(dir_name_collection, "/main_data"))
}

if (!dir.exists(dir_name_raw)){
  dir.create(dir_name_raw)}        # folder for collecting raw data

if (!dir.exists(dir_name_archive)){
  dir.create(dir_name_archive)}

# create the meta data if it does not exist 
if (!file.exists(file_name_meta_data)){
  
  # initializing meta data.frame
  meta_data = data.frame(ID          = "", 
                         parentID    = "",
                         cruise      = "",
                         max_depth   = "",
                         dataset_url = "",
                         r_file_path = "", 
                         #r_file_ind  = "",
                         data_collection = "",
                         main_file_path = "",
                         citation     = "",
                         link_from    = "",
                         loaded       = "",
                         variables    = "",
                         descriptions = "",
                         coverage     = "" 
                         )
  
  ind_ID = 1 # for filling data.frame
  
} else {
  
  # load existing meta data
  meta_data = read.table(file_name_meta_data, 
                         sep = sep_for_main_data, 
                         header = TRUE)
  
  # add a new entry and get the index
  ind_ID = dim(meta_data)[1] + 1
  
  meta_data[ind_ID, ] = ""
  
  # check if the ID is in the meta_data
  meta_data$parentID[ind_ID] = current_ID
  
}


# READ NEW DATA ------------------------------------------------
if (from_ID){
  
  # will not work for dataset collections
  
  source("HG_load_from_ID.R")
  
  # > meta data is saved and the data is returned as a data.frame
  # > only_data is returned for updating main data collection file
}

if (from_tab_data){
  
  source("HG_load_from_tab_data.R")
  
  # meta data is saved (necessary to specify: link and ID)
  # data table is returned
  
}

# UPDATE MAIN DATA ------------

# get the variables which are availiable in data set + adjust names 
# when variable is not availiable: was set to NA
adjusted_data = only_data[ , data_var_names[!is.na(data_var_names)]]
# -> will raise an error if name is not existing in the data set

# set to names of data collection file
names(adjusted_data) = alias_var_names[!is.na(data_var_names)]

if ('depth' %in% names(adjusted_data)){
  if (!all(is.na(adjusted_data$depth))){
    print('Variable water depth exists; data will adjusted to specified maximum depth.')
    adjusted_data = adjusted_data[adjusted_data$depth <= max_depth, ]
    
    depth_availiable = TRUE
  }
} else {
  
  print('no Variable found for water depth found in data set')
  depth_availiable = FALSE
  
}

# some datasets have the format yyyy-mm-ddTHH:MM:SS (some w/out :SS)
# -> adjustment so they all have the same format
if ('date_time' %in% names(adjusted_data)){
  if (all(!is.na(adjusted_data$date_time))){
    
    date_formats = c('%Y-%m-%dT%H:%M', '%Y-%m-%dT%H:%M:%S') # try formats
    
    dates = adjusted_data$date_time
    # print old date
    print(dates[!is.na(dates)][1])
    
    # adjust format (currently two formats are expected)
    dates = as.POSIXct(dates, tz = "UTC",
                       tryFormats = date_formats, 
    )
    dates = format(dates, "%Y-%m-%dT%H:%M:%S")
    
    # print example of new date
    print(dates[!is.na(dates)][1])
    
    # change date variable 
    adjusted_data$date_time = as.character(dates)
    
  }
}

# adjusting data with nutrients -----------------------------------------------
# problem: # 0.00000 values in data > change to NA 
if (data_collection == "nutrients"){
  
  # check the variable for the nutrients
  names_nutrients = c("nitrate_0", 
                      "nitrite_0", 
                      "ammonium_0", 
                      "silicate_0", 
                      "phosphate_0")
  
  # only those occuring in dataset
  names_nutrients = names_nutrients[names_nutrients %in% names(adjusted_data)]
  
  for (i in 1:length(names_nutrients)){
    
    var_to_change = names_nutrients[i]
    
    # check wether they are numeric
    adjusted_data[[var_to_change]] = as.numeric(adjusted_data[[var_to_change]])
    
  }
}


# when data points are above the minimum water depth
if (dim(adjusted_data)[1] > 0){
  
  # is it existing
  if (!file.exists(paste0(dir_name_collection, "/main_data",
                        "/main_", data_collection, ".csv"))){
    
    create_new_main_file = TRUE
  
    # the first ever read data.frame will be the initial
    # add empty variables for all aliases which are missing
    adjusted_data[ , alias_var_names[is.na(data_var_names)]] = NA
    
    # specify order of variables
    adjusted_data = adjusted_data[ , alias_var_names]
    
    # lastly add the ID than export 
    adjusted_data$ID = current_ID
    
  } else {
    
    create_new_main_file = FALSE
  
    # adjust the data for updating
    adjusted_data$ID = current_ID
    adjusted_data$X  = 1:(dim(adjusted_data)[1])
  
    # load existing main data file
    main_data = read.table(paste0(dir_name_collection, "/main_data",
                                "/main_", data_collection, ".csv"), 
                          sep = sep_for_main_data, 
                          header = TRUE)
    
    # checking whether ID exists in main file
    if (current_ID %in% main_data$ID){
      
      main_data = main_data[main_data$ID != current_ID, ]
      
    }
    
  }
} else {
    
    meta_data$data_collection[ind_ID] = 'none'
    print("No data above water maximum depth.")
    update_main_file     = FALSE
    create_new_main_file = TRUE
    
}




# USER INPUT
# create text with information about the data set.
text = ""

if (!create_new_main_file){
  
  # check whether ID is already in data set
  if(current_ID %in% main_data$ID){
    
    text = paste0("ID = ", current_ID, " is already in main file of data collection ", 
                  data_collection, "\n")
    
  } else {text = ""}
  
}

if(!depth_availiable){
  
  text = paste0(text, "No variable for water depth was found. \n")
  
} else {
  
  text = paste0(text, "")
  
}

# also put the question in front of text
text = paste0(text, "Want to update the main collection file?")

# currently user input is not used
#t = menu(c("yes", "no"), title=text) 
t = 1
if (t == 1){update_main_file = TRUE} else {update_main_file = FALSE}


# UPDATE MAIN META DATA FILE -------
if (update_main_file){
  # add infos to meta data.frame
  meta_data$variables[ind_ID]   = paste0(names(only_data), collapse = ';;')
  meta_data$cruise[ind_ID]      = ""
  meta_data$r_file_path[ind_ID] = raw_file_path
  meta_data$ID[ind_ID]          = current_ID
  meta_data$dataset_url[ind_ID] = dataset_url
  meta_data$citation[ind_ID]    = dataset_citation
  meta_data$main_file_path[ind_ID] = paste0(dir_name_collection, "/main_data", 
                                            "/main_", data_collection, ".csv")
  meta_data$data_collection[ind_ID] = data_collection
  meta_data$max_depth[ind_ID] = max_depth
  
  if (create_new_main_file){
    
    print('New main file is created.')
    
    adjusted_data$X = 1:dim(adjusted_data)[1]
    
    # creating new table
    write.table(adjusted_data, paste0(dir_name_collection, "/main_data", 
                                    "/main_", data_collection, ".csv"), 
              row.names = F, sep = sep_for_main_data, 
              na= "NA")
    
  } else {
  
  # merging new loaded data with existing main data  
  main_data = assemble_data_frames(main_data, adjusted_data)
  
  write.table(main_data, paste0(dir_name_collection, "/main_data",
                                  "/main_", data_collection, ".csv"), 
              row.names = F, sep = sep_for_main_data, 
              na = "NA")
  }
  
  write.table(meta_data, file_name_meta_data, row.names = F, 
              sep = sep_for_main_data, na = "NA")
  
}






