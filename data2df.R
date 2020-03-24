# read in data as vector/matrix
# ada, acc have 10 seconds more data than HR, delete those data with subsetting
heart_rate = read.csv("../data/LitianZhou/HR.csv", skip = 1, header = F)[[1]]
eda = read.csv("../data/LitianZhou/EDA.csv", skip = 1, header = F)[[1]][-c(1:10*4)]
acc = read.csv("../data/LitianZhou/ACC.csv")[-c(1:10*32),]
tags <- read.table("../data/LitianZhou/tags.csv", quote="\"", comment.char="")

# calculate mean value of ACC, EDA and TEMP in each second
mean_per_second = function(series, sampling_freq) {
  one_sec_window = seq(1,length(series), by=sampling_freq)
  total_sec = ceiling(length(series)/sampling_freq)
  new_series = rep(NA, total_sec-1)
  for (s in 1:(total_sec-1)) {
    one_sec_data = one_sec_window[s]:(one_sec_window[s]+sampling_freq-1)
    new_series[s] = mean(series[one_sec_data])
  }
  return(new_series)
}
acc = mean_per_second(sqrt(acc[,1]^2+acc[,2]^2+acc[,3]^2), sampling_freq = 32)
eda = mean_per_second(eda[-c(1:7)], sampling_freq = 4)

cut_tail = min(length(heart_rate),length(acc),length(eda))
heart_rate = heart_rate[1:cut_tail]
acc = acc[1:cut_tail]
eda = eda[1:cut_tail]

timezone = 'America/Detroit'
start_time_sec = as.numeric(read.csv("../data/LitianZhou/HR.csv", header = F, nrows = 1))
total_sec = length(heart_rate)
time_line_linux = start_time_sec + 1:total_sec
time_line = as.POSIXlt(time_line_linux, origin = "1970-01-01",tz = timezone)

df = data.frame(time_line, time_line_linux, heart_rate, eda, acc)
df$sleep = 0
df$sleep = as.numeric(df$time_line > tags[1,] & df$time_line < tags[2,])

head(df,10)
