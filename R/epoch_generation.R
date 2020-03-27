# input: 
# @data: the raw data frame (or matrix?)
# @window_size: the length of each epoch in second (default: 10min)

# output:
# a data frame of 8 varibles: 
# @window_time: the median time of the epoch window
# @mean_xxx: the mean value of the epoch window
# @sd_xxx: the standard error of the epoch window

epoch_generation = function(df, window_size = 600) {
  windows = seq(1, nrow(df), by = window_size)
  windows = windows[-length(windows)]
  mean_hr = numeric(0)
  sd_hr = numeric(0)
  mean_eda = numeric(0)
  sd_eda = numeric(0)
  mean_acc = numeric(0)
  sd_acc = numeric(0)
  sleep = numeric(0)
  window_time = df$time_line_linux[windows + window_size / 2]
  for (i in 1:length(windows)) {
    mean_hr[i] = mean(df$hr[windows[i]:(windows[i] + window_size - 1)])
    sd_hr[i] = sd(df$hr[windows[i]:(windows[i] + window_size - 1)])
    mean_eda[i] = mean(df$eda[windows[i]:(windows[i] + window_size - 1)])
    sd_eda[i] = sd(df$eda[windows[i]:(windows[i] + window_size - 1)])
    mean_acc[i] = mean(df$acc[windows[i]:(windows[i] + window_size - 1)])
    sd_acc[i] = sd(df$acc[windows[i]:(windows[i] + window_size - 1)])
    sleep[i] = all(df$sleep[windows[i]:(windows[i] + window_size - 1)] == 1) + 0
  }
  answer = list(
    window_time = window_time,
    mean_hr = mean_hr,
    sd_hr = sd_hr,
    mean_eda = mean_eda,
    sd_eda = sd_eda,
    mean_acc = mean_acc,
    sd_acc = sd_acc,
    sleep = sleep
  )
  answer=as.data.frame(answer)
  return(answer)
}
