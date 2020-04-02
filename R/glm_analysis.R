load("data/normalization1.Rdata")

model = glm(
  sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc,
  data = total_data1,
  family = binomial()
)


make_plot = function(model, people = "LitianZhou",data_df) {
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

# make_plot(model,data_df=data_df)
# make_plot(model, people = "BangyaoZhao",data_df=data_df)
# make_plot(model, people = "QingzhiLiu",data_df=data_df)
# make_plot(model, people = "NingyuanWang",data_df=data_df)
# make_plot(model, people = "ChenyiYu",data_df=data_df)


data_epoch <- readRDS("data/data_epoch.rds")
model2 = glm(
  formula = sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc +
    mean_temp + sd_temp,
  data = bind_rows(data_epoch),
  family = binomial()
)
# make_plot(model2,data_df=data_epoch)
# make_plot(model2, people = "BangyaoZhao",data_df=data_epoch)
# make_plot(model2, people = "QingzhiLiu",data_df=data_epoch)
# make_plot(model2, people = "NingyuanWang",data_df=data_epoch)
# make_plot(model2, people = "ChenyiYu",data_df=data_epoch)

#normalization1
model%>%summary()
#normalization2
model2%>%summary()


