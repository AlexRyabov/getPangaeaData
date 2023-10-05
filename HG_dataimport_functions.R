# date        2023-08-21
# project     
# R Version   4.2.1 (2022-06-23 ucrt)
# R packages  /

# miscellaneous functions
# -------------------------------------------------------------------------------

# functions -----

# finding/giving substring after specified amount of characters
find_string_part = function(string_origin, string_ident){
  
  # returns remaining characters after a key-string (key-word)
  # in:
  # string_origin  := char, original string
  # string_ident   := char, search key word, every character after this will be read
  #
  # out:
  # string_part    := char, every character in original string after search key word
  
  # for finding ID in url or doi: "PANGAEA."
  
  # index where the indicator starts
  ind = gregexpr(string_ident, string_origin)[[1]][1] + nchar(string_ident)
  # find corresponding remaining characters after key word in original string
  string_part = substring(string_origin, ind, nchar(string_origin))
  
  return(string_part)
}

paste_varnames = function(data, sep){
  
  # from data.frame() paste all variable names with a given seperator
  # in:
  # sep  := character between the var names
  # data := single data.frame from which variable names are extracted
  # out:
  # pasted_varnames
  
  # find names
  var_names = names(data)
  # paste together with a sep-character
  pasted_varnames = paste0(var_names, collapse = sep)
  
  return(pasted_varnames)
}

assemble_data_frames = function(main_data, new_data){
  
  # merging the data frames (might have different variables); will make a data.frame() containing
  # all variables 
  # in:
  # main_data := data.frame, of any given variable structure; order of variables is given 
  #              by this data.frame
  # new_data  := data.frame, of any given variable structure; variables with the same names
  #              will appear in the same colum 
  # out: 
  # main_data := data.frame, updated main_data 
  
  
  # get all names
  names_main = names(main_data); names_new  = names(new_data)
  
  # get variable which do not exist in other data.frame
  missing_vars_new  = setdiff(names_main, names_new)
  missing_vars_main = setdiff(names_new, names_main)
  
  # add empty variables to both data.frames
  main_data[missing_vars_main] = NA
  new_data[missing_vars_new]   = NA
  
  # combine both data.frames (since naming convention is the same in both data.frames
  # (specified by the chosen alias) the order of variables does not matter)
  main_data = rbind(main_data, new_data)
  
  return(main_data)
}




