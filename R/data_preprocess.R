source('R/data2df.R')
source('R/epoch_generation.R')
source('R/ratio_standardization.R')

library(ggplot2)

#about 30s
data = list(
  LitianZhou = data2df(people_id = "LitianZhou", folder = "LitianZhou"),
  
  NingyuanWang = list(
    Day1 = data2df(people_id ="NingyuanWang", folder = "NingyuanWang/Day1"),
    Day2 = data2df(people_id="NingyuanWang", folder = "NingyuanWang/Day2")
  ),
  
  ChenyiYu = list(
    daytime1 = data2df(people_id="ChenyiYu", folder = "ChenyiYu/daytime1"),
    night1 = data2df(people_id="ChenyiYu", folder = "ChenyiYu/night1"),
    daytime2 = data2df(people_id="ChenyiYu", folder = "ChenyiYu/daytime2"),
    night2 = data2df(people_id="ChenyiYu", folder = "ChenyiYu/night2")
  ),
  
  BangyaoZhao = data2df(people_id="BangyaoZhao", folder = "BangyaoZhao"),
  
  QingzhiLiu = data2df(people_id="BangyaoZhao",folder = "QingzhiLiu")
)

#check
# data$LitianZhou %>% ggplot(mapping = aes(x = time_line)) + geom_line(mapping = aes(y = hr, color = sleep))

# divide into epochs at the length of m minutes:
m = 600
data_epoch = list()
data_epoch$LitianZhou = epoch_generation(data$LitianZhou, m)
data_epoch$BangyaoZhao = epoch_generation(data$BangyaoZhao, m)
data_epoch$QingzhiLiu = epoch_generation(data$QingzhiLiu, m)
data_epoch$NingyuanWang$Day1 = epoch_generation(data$NingyuanWang$Day1, m)
data_epoch$NingyuanWang$Day2 = epoch_generation(data$NingyuanWang$Day2, m)
data_epoch$ChenyiYu$daytime1 = epoch_generation(data$ChenyiYu$daytime1, m)
data_epoch$ChenyiYu$night1 = epoch_generation(data$ChenyiYu$night1, m)
data_epoch$ChenyiYu$daytime2 = epoch_generation(data$ChenyiYu$daytime2, m)
data_epoch$ChenyiYu$night2 = epoch_generation(data$ChenyiYu$night2, m)

data_epoch$NingyuanWang = bind_rows(data_epoch$NingyuanWang)
data_epoch$ChenyiYu = bind_rows(data_epoch$ChenyiYu)

# saveRDS(data_epoch,file = "data/data_epoch.rds")

