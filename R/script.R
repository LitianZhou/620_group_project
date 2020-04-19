source('data2df.R')
library(dplyr)
library(readr)
library(xlsx)

my_data = data2df()

my_data %>%
  mutate(epoch = row_number() %/% 300) %>%
  group_by(epoch) %>%
  summarise(
    E4_ID = 6,
    Sleep = sum(sleep) / n(),
    Sex = 0,
    Age = 25,
    VE = 0,
    D.VE = 40,
    Day = substr(as.Date(min(time_line)), 10, 10) %>% as.numeric() +1,
    W.hours = 10,
    ACC_Mean = mean(acc),
    ACC_SD = sd(acc),
    ACC_Q1 = quantile(acc)[2],
    ACC_Q2 = quantile(acc)[3],
    ACC_Q3 = quantile(acc)[4],
    TEMP_Mean = mean(temp),
    TEMP_SD = sd(temp),
    TEMP_Q1 = quantile(temp)[2],
    TEMP_Q2 = quantile(temp)[3],
    TEMP_Q3 = quantile(temp)[4],
    HR_Mean = mean(hr),
    HR_SD = sd(hr),
    HR_Q1 = quantile(hr)[2],
    HR_Q2 = quantile(hr)[3],
    HR_Q3 = quantile(hr)[4],
    EDC_Mean = mean(eda),
    EDC_SD = sd(eda),
    EDC_Q1 = quantile(eda)[2],
    EDC_Q2 = quantile(eda)[3],
    EDC_Q3 = quantile(eda)[4],
    n = n()
  ) %>%
  filter(Sleep==0|Sleep==1,n==300)%>%
  select(
    E4_ID,
    Sleep,
    Sex,
    Age,
    VE,
    D.VE,
    Day,
    W.hours,
    ACC_Mean,
    ACC_SD,
    ACC_Q1,
    ACC_Q2,
    ACC_Q3,
    TEMP_Mean,
    TEMP_SD,
    TEMP_Q1,
    TEMP_Q2,
    TEMP_Q3,
    HR_Mean,
    HR_SD,
    HR_Q1,
    HR_Q2,
    HR_Q3,
    EDC_Mean,
    EDC_SD,
    EDC_Q1,
    EDC_Q2,
    EDC_Q3
  )%>%
  as.data.frame()->
  data

write.xlsx(data,file = "LitianZhou.xls")
