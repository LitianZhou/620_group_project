source('R/ratio_standardization.R')

library(ggplot2)
library(readxl)
library(dplyr)

data_final = list()
for(id in 1:25) {
  if(id < 10) data_final[[id]] = read_excel(paste0("data/final_project_data/Student0",id, ".xls"))
  else data_final[[id]] = read_excel(paste0("data/final_project_data/Student",id, ".xls"))
}

for(id in 1:25) {
  data_final[[id]] = data_final[[id]] %>% select(matches(c("E4_ID","Sleep", "Sex", "Age", "VE", "D.VE", "Day", "W.hours", 
                                             "ACC_Mean", "ACC_SD", "ACC_Q1", "ACC_Q2", "ACC_Q3", 
                                             "TEMP_Mean", "TEMP_SD", "TEMP_Q1", "TEMP_Q2", "TEMP_Q3", 
                                             "HR_Mean", "HR_SD", "HR_Q1", "HR_Q2", "HR_Q3", 
                                             "EDA_Mean", "EDA_SD", "EDA_Q1", "EDA_Q2", "EDA_Q3"),
                                             ignore.case = TRUE))
  colnames(data_final[[id]]) = toupper(colnames(data_final[[id]]))
}


#combine rows and delete unwanted colomn "SLEEP_OLD" 
#have no clue how does it enter...
total_data_final = bind_rows(data_final)
total_data_final = select(total_data_final, -SLEEP_OLD)

# check NAs and deletion:
apply(is.na(total_data_final), 2, which)
total_data_final = total_data_final[-3709,]

#saveRDS(total_data_final,file = "data/total_data_final.rds")

# normalization by scaling for ACC, TEMP, HR and EDA related covariates
normalize_vector =toupper(c("ACC_Mean", "ACC_SD", "ACC_Q1", "ACC_Q2", "ACC_Q3", 
                            "TEMP_Mean", "TEMP_SD", "TEMP_Q1", "TEMP_Q2", "TEMP_Q3", 
                            "HR_Mean", "HR_SD", "HR_Q1", "HR_Q2", "HR_Q3", 
                            "EDA_Mean", "EDA_SD", "EDA_Q1", "EDA_Q2", "EDA_Q3"))  

for (feature in normalize_vector) {
  scaled_feature = total_data_final %>% group_by(E4_ID) %>% select(feature) %>% scale()
  total_data_final[[which(normalize_vector==feature)+8]] = scaled_feature[,2]
}

saveRDS(total_data_final, file = "data/total-data_final_normalized.rds")
