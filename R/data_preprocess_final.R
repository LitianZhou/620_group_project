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
  colnames(data_final[[id]]) = tolower(colnames(data_final[[id]]))
}



total_data_final = bind_rows(data_final)

#saveRDS(total_data_final,file = "data/total_data_final.rds")

