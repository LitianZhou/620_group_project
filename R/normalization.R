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
# save(data_df,total_data1, file = "./data/normalization1.Rdata")

############ Normalizarion 2


