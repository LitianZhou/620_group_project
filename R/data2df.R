require(readr)
require(dplyr)

data2df = function(folder) {
  # read in data as vector/matrix
  # ada, acc have 10 seconds more data than HR, delete those data with subsetting
  
  folder = paste0("data/", folder)
  hr = read.csv(paste0(folder, "/HR.csv"),
                        skip = 2,
                        header = F)[[1]]
  eda = read.csv(paste0(folder, "/EDA.csv"),
                 skip = 2,
                 header = F)[[1]][-c(1:10 * 4)]
  acc = read.csv(paste0(folder, "/ACC.csv"),
                 skip = 2,
                 header = F)[-c(1:10 * 32), ]
  temp = read.csv(paste0(folder, "/temp.csv"),
                 skip = 2,
                 header = F)[-c(1:10 * 4), ]
  
  tags <- read_table2(paste0(folder, "/new_tags.csv"),col_names = FALSE)
  names(tags) = c("time_line_linux", "event")
  
  # calculate mean value of ACC, EDA and TEMP in each second
  mean_per_second = function(series, sampling_freq) {
    one_sec_window = seq(1, length(series), by = sampling_freq)
    total_sec = ceiling(length(series) / sampling_freq)
    new_series = rep(NA, total_sec - 1)
    for (s in 1:(total_sec - 1)) {
      one_sec_data = one_sec_window[s]:(one_sec_window[s] + sampling_freq - 1)
      new_series[s] = mean(series[one_sec_data])
    }
    return(new_series)
  }
  acc = mean_per_second(sqrt(acc[, 1] ^ 2 + acc[, 2] ^ 2 + acc[, 3] ^ 2), sampling_freq = 32)
  eda = mean_per_second(eda[-c(1:7)], sampling_freq = 4)
  temp = mean_per_second(temp[-c(1:7)], sampling_freq = 4)
  
  cut_tail = min(length(hr), length(acc), length(eda))
  hr = hr[1:cut_tail]
  acc = acc[1:cut_tail]
  eda = eda[1:cut_tail]
  temp = temp[1:cut_tail]
  
  timezone = 'America/Detroit'
  start_time_sec = as.numeric(read.csv(
    paste0(folder, "/HR.csv"),
    header = F,
    nrows = 1
  ))
  total_sec = length(hr)
  time_line_linux = start_time_sec + 1:total_sec
  time_line = as.POSIXlt(time_line_linux, origin = "1970-01-01", tz = timezone)
  
  sleep_tags = filter(tags, event %in% c("GoToSleep", "WakeUp"))
  df = data.frame(time_line, time_line_linux, hr, eda, acc, temp)
  df$sleep = F
  for (i in 1:nrow(sleep_tags)) {
    indi = df$time_line > sleep_tags$time_line_linux[i]
    df$sleep[indi] = !df$sleep[indi]
  }
  df$sleep = df$sleep + 0
  return(df)
}


