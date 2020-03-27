source('R/data2df.R')
library(ggplot2)

#about 30s
data = list(
  LitianZhou = data2df(folder = "LitianZhou"),
  
  NingyuanWang = list(
    Day1 = data2df(folder = "NingyuanWang/Day1"),
    Day2 = data2df(folder = "NingyuanWang/Day2")
  ),
  
  ChenyiYu = list(
    daytime1 = data2df(folder = "ChenyiYu/daytime1"),
    night1 = data2df(folder = "ChenyiYu/night1"),
    daytime2 = data2df(folder = "ChenyiYu/daytime2"),
    night2 = data2df(folder = "ChenyiYu/night2")
  ),

  BangyaoZhao = data2df(folder = "BangyaoZhao"),
  
  QingzhiLiu = data2df(folder = "QingzhiLiu")
)

#check
# data$LitianZhou %>% ggplot(mapping = aes(x = time_line)) + geom_line(mapping = aes(y = hr, color = sleep))

# divide into epochs at the length of m minutes:
m = 600
data$LitianZhou = epoch_generation(data$LitianZhou, m)
data$BangyaoZhao = epoch_generation(data$BangyaoZhao, m)
data$QingzhiLiu = epoch_generation(data$QingzhiLiu, m)
data$NingyuanWang$Day1 = epoch_generation(data$NingyuanWang$Day1, m)
data$NingyuanWang$Day2 = epoch_generation(data$NingyuanWang$Day2, m)
data$ChenyiYu$daytime1 = epoch_generation(data$ChenyiYu$daytime1, m)
data$ChenyiYu$night1 = epoch_generation(data$ChenyiYu$night1, m)
data$ChenyiYu$daytime2 = epoch_generation(data$ChenyiYu$daytime2, m)
data$ChenyiYu$night2 = epoch_generation(data$ChenyiYu$night2, m)



# use ratio to standardize the data (optional!):
data_df = NULL
ind = 1
for (people in data) {
  #optional
  #data_df[[ind]] = mean_ratio_standardization(people) 
  data_df[[ind]] = med_ratio_standardization(people)
  ind = ind+1
}

# combine the data of five group members:
total_data = bind_rows(data_df)
save(total_data, file = "./data/total_data.csv")


