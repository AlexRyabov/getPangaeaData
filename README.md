# getPangaeaData
Dowload CTD, Nutrients and chl data from Pangaea database.
Thanks @Merle Schütt

This script is intended to load chlorophyll, nutrient and CTD data from the **Pangaea** database. 

## Preparation

Open R and install the **pangear** package

Download all files from this repository and create a raw_data\archive folder in the folder with these files. This folder will contain the raw data from **Pangaea**. Once the data has been downloaded, this folder can be deleted. 

If necessary, edit two Excel tables containing IDs of files to be downloaded and matches between column names in **Pangaea** and local database. 
The **dataset_links.xlsx** file stores the list of datasets from **Pangaea** to be downloaded. In this file, you need to fill in the column ID (dataset number in **Pangaea**) and data_collection (Chlorophyll, CTD or nutrients). The other columns are optional. 
The file **variable_names_in_datasets.xlsx** stores a dictionary of column names correspondences in the **Pangaea** database and in the local database. You need to fill in the following columns: 

- **ID** ....ID of the dataset in **Pangaea**
- **data_var_names** column name in **Pangaea** database
- **alias_var_names** name of the column in the local collection these names should of course be the same for all files in the given collection.
- **data_collection** collection name (Chlorophyll, CTD or nutrients)
- **column**  the number of the column in the merged collection file

## Run 

Run the script **HG_create_or_update_collection.R** (must be in the working directory of R). It should create a folder **selected_data_collection** with downloaded and merged data inside it: 

- data_selected_Chlorophyll/main_data/main_Chlorophyll.csv, 
- data_selected_CTD/main_data/ main_CTD.csv, 
- data_selected_nutrients/main_data/ main_nutrients.csv 

these files also have an ID column which refers to **Pangaea** ID.

## Notes
Note that the script does not remove duplicates, so if the same data is included in several **Pangaea** datasets and these datasets are included in **dataset_links.xlsx** file, these data will appear several times in the final files, but will have different **Pangaea** ID.
