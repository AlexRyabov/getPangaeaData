# date        2023-08-20
# project     
# R Version   4.2.1 (2022-06-23 ucrt)
# R packages  /

# add .xlsx (only updating, not for initial main collection file)
# -------------------------------------------------------------------------------

source("HG_dataimport_functions.R")

# from package use function/read sheet
current_data = readxl::read_xlsx("raw_data/archive/PS126 Chlorophyll a Fluorometer EMNoethig 01 12 21 Kopie AK.xlsx")

data_collection = "Chlorophyll"

data_var_names  = c("station (event#)",         
                    "latitude", 
                    "longitude", 
                    "depth",               
                    "chlorophyll a (µg/L)")

alias_var_names = c("event","lat", "long","depth", "chlorophyll_a_0")

# set ID name to file name
ID_name = "PS126 Chlorophyll a Fluorometer EMNoethig 01 12 21 Kopie AK.xlsx"



# only necessary 
current_data = current_data[data_var_names]

# adjust names 
names(current_data) = alias_var_names

# add index in data
current_data$X = 1:dim(current_data)[1]

# add ID 
current_data$ID = ID_name

# read existing data 
main_data = read.csv(file = "selected_data_collection/data_selected_Chlorophyll/main_data/main_Chlorophyll.csv")

# meta data specify per hand!
updated_data = assemble_data_frames(main_data, current_data)

write.csv(updated_data, "selected_data_collection/data_selected_Chlorophyll/main_data/main_Chlorophyll.csv", 
          row.names = F)

#write.csv(current_data, "selected_data_collection/data_selected_Chlorophyll/ID_PS126 Chlorophyll a Fluorometer EMNoethig 01 12 21 Kopie AK.csv", 
#          row.names = F)


meta_data = read.csv(file = "selected_data_collection/meta_data_main_Chlorophyll.csv")

ind = dim(meta_data)[1]+1

meta_data[ind, ] = NA

meta_data$ID[ind] = ID_name
meta_data$dataset_url[ind] = "not on pangaea"
meta_data$r_file_path[ind] = paste0("raw_data/archive/", ID_name)
meta_data$data_collection[ind] = "Chlorophyll"

meta_data$variables[ind] = paste_varnames(current_data, sep = ";-;")
meta_data$cruise[ind] = "ps126"

write.csv(meta_data,  "selected_data_collection/meta_data_main_Chlorophyll.csv", 
          row.names = FALSE)

