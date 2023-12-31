INFOS and WORKFLOW  2023-10-05 ----------------

1. UPDATING DATA COLLECTION (ONE DATASET) 
2. CREATING DATA COLLECTION FROM LIST (INITIAL)

3. CRITERIA FOR DATA 
4. FOR SEARCH QUERY IN PANGAEA DATABASE
5. FILE INFO AND STRUCTURE
6. PROBLEMS WITH/IN DATASETS

----------------------------------------------

 
1. UPDATING DATA COLLECTION (ONE DATASET) -------------------------------------------
 
 see 4. FILE INFO AND STRUCTURE
 
 HG_create_or_update_collection.R with add_one_dataset (line 8) set to TRUE
 
1.1 using .tab data
1.2 using R-library pangear

1.1 using .tab data -----------------------------------------------------------------

- file of dataset must be in the directory /main/raw_data/archive
- HG_create_or_update.R must be updated according to that dataset

- necessary libraries: None	

- necessary specifications (in HG_create_or_update_collection.R): 

	> line 23: 		ID of dataset; get from pangaea website when downloading 
	> line 25f.: 	from_ID must be set to FALSE; from_tab_data must be set to TRUE
	> line 28:		specify the file name of the data set (must be in folder raw_data > archive)
	> line 41:		sepecify data collection name 
	> line 42ff.:	specify alias_var_names (names of variables in  main collection file) 
					and data_var_names (names of variables in dataset); order of elements 
					must be the same
		
- optional specifications
		
	> line 17: 		maximum depth for selecting the datapoints from new dataset

> the working directory must be set in the R-session (to folder of script)
  (in R Studio GUI: Session > Set Working Directory > To Source File Location
  
> run HG_create_or_update_collection.R	

> DISABLED: script will ask for user input (before updating the main file); type 'yes' when 
  dataset should be added to main collection file (see HG_add_one_dataset.R line 271ff.)
  
> check citation and link in meta data!
				
	

1.2 using R-library pangaear ---------------------------------------------------------

	see 1. with following adjustements: 

- no dataset must be downloaded
- ID from pangaea website must be availiable 

- necessary libraries: 

	pangaear (Vers. 1.1.0)

- necessary specifications
	
	> line 23f.		: from_ID must be set to TRUE; from_tab_data must be set to FALSE

 
2. CREATING OR UPDATING DATA COLLECTION(S) FROM LIST ---------------------------------------------------
 
 see 4. FILE INFO AND STRUCTURE
 
 HG_create_or_update_collection.R with add_one_dataset (line 8) set to FALSE

- necessary files (in main folder):

	dataset_links.xlsx 
	variable_names_in_datasets.xlsx
	
- necessary libraries:

	pangaear (Vers. 1.1.0)
	readxl (Vers. 1.4.1)
	
>	the working directory must be set in the R-session (to folder of script)
	(in R Studio GUI: Session > Set Working Directory > To Source File Location
> 	run HG_create_or_update_collection.R


3. CRITERIA FOR DATA -------------------------------------------------------------------------
 
- cruises: 
- date:    2009-01-01 to 2023-07-30
 
- data is inside the coordinates: (== HAUSGARTEN area)
	coordinates c(W, E, S, N) = c(-6, 12, 78, 80)
- from datasets data is saved which is from a depth above 120 m (specified in awi  


4. FOR SEARCH QUERY IN PANGAEA DATA BASE --------------------------------------------------

search_keywords = c("nitrate", 
                     "nitrite", 
                     "phosphate",
                     "silicate",
                     "ammonium",
                     "chlorophyll", 
                     "conductivity") + "water" + <cruise>					 
					  



5. FILE INFO AND STRUCTURE ------------------------------------------------------------------
 
raw_data
	
	archive
	> folder, contains all .RDS files if data was downloaded via pangaear; if .tab datasets 
	  are used they must be in this folder

selected_data_collection

	data_selected_<data collection name>
	> folder per collection 
	
		main_data
		
			main_<data collection name>
			> 
			
			"event"					:= str, description of event
			"date_time"				:= str, Date (and Time) 
			"long"					:= float, Longitude (sometimes derived from coverage)
			"lat"					:= float, Latitude (sometimes derived from coverage)
			"elevation" 			:= float, Elevation measurement [m]
			"depth"					:= float, Water depth [m]
			"temp"					:= float, Water Temperature [°C]
			
			"ID"					:= str, ID of dataset (also included in meta_data_selected.csv)
			"X"						:= int, index of datapoint in dataset

			_CTD
			
PAR			"cond_0"				:= float, Conductivity [mS/cm]
PAR			"salin_0"				:= float, Salinity 	
			
			_Chlorophyll
			
PAR			"chlorophyll_a_0"		:= float, Chlorophyll a [µg/l]; (_1 [µg/cm**3]; _2 [mg/m**3])
PAR			"chlorophyllide_a_0"	:= float, Chlorophyllide a [µg/l] 
PAR			"chlorophyllide_b_0"	:= float, Chlorophyllide b [µg/l] 
PAR			"chlorophyll_b_0"		:= float, Chlorophyll b [µg/l]
PAR			"chlorophyll_c3_0"		:= float, Chlorophyll c3 [µg/l]
			
			_nutrients
			
PAR			"nitrate_0"				:= float, Nitrate [NO3]- [µmol/l] 		
PAR			"nitrite_0"				:= float, Nitrite [NO2]- [µmol/l]
PAR			"ammonium_0"			:= float, Ammonium [NH4]+ [µmol/l]
PAR			"silicate_0"			:= float, Silicate Si(OH)4 [µmol/l]
PAR			"phosphate_0"			:= float, Phosphate [PO4]3- [µmol/l]
			

			
	meta_data_main_<data collection name>.csv	
	> 	contains meta data for all included datasets per data collection, same structure for every collection
	
	"ID"			:= str, 'ID' of dataset 
	"parentID"		:= str, 'parent'-ID of parant dataset
	"cruise"		:= str, cruise name, not specified in script
	"max_depth"     := float, maximum depth for selecting data points which are added to main collection file
	"dataset_url"	:= str, link of dataset https://doi.org/10.1594/PANGAEA.<ID-value>
	"r_file_path"   := str, path-name for .RDS-file or .tab file (relative to main_folder)
  	"data_collection" := str, name of data collection 
	"main_file_path":= str, path-name of main colelction file where dataset is included
	"citation"		:= str, citation of dataset, authors, date, name - check after updating main file!
	"link_from"		:= /
	"loaded"		:= /
	"variables"		:= str, variable-names (short) format: '<variable-name 1> [<unit 1>]; <variable-name 2> [<unit 2>]; ...'
	"descriptions"	:= str, variable-descriptions (long): format: '<variable-description 1>; <variable-description 2>; ...'
	"coverage"		:= str, from meta data of dataset, contains information about latitude, longitude, date/time (and water depth)	
	"n_child_data"	:= /
		

add_xlsx_data.R
> script for adding raw_data/archive/PS126 Chlorophyll a Fluorometer EMNoethig 01 12 21 Kopie AK.xlsx to exsiting
main file of Chlorophyll collection
> for using with othe tabes: adjustments need to be made: adjustement fo date_time is not included

dataset_links.xlsx 
*should exist before running any scripts when Collection should be created/updated from this list 
> 	list of datasets which should be used for initial main collection file(s)

	"url"				:= str, link of dataset https://doi.org/10.1594/PANGAEA.<ID-value>
	"ID"				:= str, 'ID' of dataset 
	"citation"			:= str, citation of dataset, authors, date, name
	"data_collection"   := str, name of data collection 
	"link_from"			:= str, note where link is from 
	"cruise"			:= str, cruise name
	"note_1"			:= str, note (from alex)
	"availiable"		:= float, dataset availiable for cruise and collection?
	"note_2"			:= str, not (from merle)

HG_add_one_dataset.R
> get data and metadata, updates main collection file 

HG_create_or_update_collection.R
> main script for creating initial file collection from list or updating main 
collection (one dataset)

HG_dataimport_functions.R
> miscellenoius functions

HG_load_from_ID.R
> loads one data set and selects meta data from ID with R-library pangear

HG_load_from_tab_data.R
> loads one data set and selects meta data from from .tab file

variable_names_in_datasets.xlsx
> 	list of all variable names in datasets (see dataset_links.xlsx) and corresponding name of 
	variable in main collection file(s)
	
	"ID"				:= str, 'ID' of dataset 
	"data_var_names"	:= str, name of variable in dataset 
	"alias_var_names"   := str, name of variable in main collection file
	"data_collection"	:= str, name of data collection
	"column"			:= int, column of variable in main data collection file


6. PROBLEMS WITH/IN DATASETS ------------------------------------------------------------------------ 2023-04-08

> 907355: no NO3- but sum of NO3- and NO2- (variable not included in main file)
> 906132: no NO3- but sum of NO3- and NO2- (variable not included in main file)

> 834680: no NH4+

> 949666: no event label 

> 943220: name of Water Depth [m] occurs as Water sed [m] when laoded with pangear 

> 932068 (example)
> Nitrate values: with # (changed to NA's in dataset see HG_add_one_dataset.R line 157ff.)
1,"PS107_22-6","2017-08-03T08:22:00",-2.733203,78.817635,NA,10,-0.625,"#0.000000000","#0.0000","#0.0000","8.370000000",0.54,NA,932068
https://doi.pangaea.de/10.1594/PANGAEA.932068


> 907355 
- missing date/time (possible to derive from date per event, not done)
https://doi.pangaea.de/10.1594/PANGAEA.907355
 
> 'duplicates/more than one measurement' inside a dataset 
ID	date_time				long	lat		depth	note
882217	2014-06-22T15:37:00	4,1788	79,065	76,5	two different values for all nutrients in same dataset
882217	2014-06-23T21:29:00	2,7908	79,1487	10,7	two different values for all nutrients in same dataset
906132	2016-06-28T21:09:00	3,526	79,0568	10		two different (but similair) values for all nutrients in same dataset
906132	2016-06-28T21:09:00	3,526	79,0568	15		two different (but similair) values for all nutrients in same dataset
906132	2016-06-28T21:09:00	3,526	79,0568	35		two different (but similair) values for all nutrients in same dataset
906132	2016-06-28T21:09:00	3,526	79,0568	75		two different (but similair) values for all nutrients in same dataset
906132	2016-06-28T21:09:00	3,526	79,0568	100		three different (but similair) values for all nutrients in same dataset
906132	2016-06-28T21:09:00	3,526	79,0568	100		three different (but similair) values for all nutrients in same dataset
906132	2016-07-01T19:40:00	-4,6503	78,9367	5		two different (but similair) values for all nutrients in same dataset
906132	2016-07-09T11:24:00	11,0925	79,0263	5		two different values for all nutrients in same dataset
906132	2016-07-09T11:24:00	11,0925	79,0263	18		two different values for all nutrients in same dataset
906132	2016-07-09T11:24:00	11,0925	79,0263	90		two different values for all nutrients in same dataset
906132	2016-07-09T11:24:00	11,0925	79,0263	100		two different values for all nutrients in same dataset
907355						5,6483	79,0206	50		three different (but similair) values for all nutrients in same dataset
907355						5,6483	79,0206	50		three different (but similair) values for all nutrients in same dataset

> for nutrient data: 
- negative values (also in original datasets)
- quality flags for every value (not considered or saved)
see https://doi.pangaea.de/10.1594/PANGAEA.906132


 
 


