




model = glm(
  sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc,
  data = total_data,
  family = binomial()
)


make_plot = function(model, people = "LitianZhou") {
  prediction = predict(model, data_df[[people]], type = "response")
  data.frame(
    prediction = prediction,
    truth = data_df[[people]]$sleep,
    time = as.POSIXlt(data_df[[people]]$window_time,
                      origin = "1970-01-01",
                      tz = 'America/Detroit')
  ) %>% ggplot(mapping = aes(x = time, y =
                               prediction)) + geom_line(mapping = aes(color =
                                                                        truth))
}

make_plot(model)
make_plot(model,people = "BangyaoZhao")
make_plot(model,people = "QingzhiLiu")
make_plot(model,people = "NingyuanWang")
make_plot(model,people = "ChenyiYu")





