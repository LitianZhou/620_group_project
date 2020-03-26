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
# data$LitianZhou %>% ggplot(mapping = aes(x = time_line)) + geom_line(mapping = aes(y =
#                                                                         heart_rate, color = sleep))
