data_epoch <- readRDS("data/data_epoch.rds")
source('R/epoch_generation.R')
source('R/ratio_standardization.R')

############ Normalization 1
# use ratio to standardize the data (optional!):
data_df = NULL
ind = 1
for (people in data_epoch) {
  #optional
  #data_df[[ind]] = mean_ratio_standardization(people)
  data_df[[ind]] = med_ratio_standardization(people)
  ind = ind + 1
}
names(data_df) = names(data_epoch)

# combine the data of five group members:
total_data1 = bind_rows(data_df)
# save(data_df1,total_data1, file = "./data/normalization1.Rdata")

############ Normalizarion 2
# use the package called limma, some warnings during installation and loading
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("limma")
library("limma")

total_data = bind_rows(data_epoch)
# total_data$people_id = as.factor(total_data$people_id)
data_only_trans = t(total_data %>% select(-window_time, -sleep, -people_id))
data_epoch_trans = removeBatchEffect(data_only_trans, batch=total_data$people_id)

total_data2 = as.data.frame(t(data_epoch_trans))
total_data2$window_time = total_data$window_time
total_data2$sleep = total_data$sleep
total_data2$people_id = total_data$people_id

# save(total_data2, file = "./data/normalization2.Rdata")

