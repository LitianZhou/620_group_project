logistic_model_with_batch = glm(
  sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc + people_id,
  data = bind_rows(data_epoch),
  family = binomial()
)
summary(logistic_model_with_batch)

load("data/normalization1.Rdata")
logistic_model_eli_batch1 = glm(
  sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc + people_id,
  data = bind_rows(total_data1),
  family = binomial()
)
summary(logistic_model_eli_batch1)

load("data/normalization2.Rdata")
logistic_model_eli_batch2 = glm(
  sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc + people_id,
  data = bind_rows(total_data2),
  family = binomial()
)
summary(logistic_model_eli_batch2)
anova(logistic_model_eli_batch2, logistic_model_with_batch,test="LRT" )

load("data/normalization3.Rdata")
logistic_model_eli_batch3 = glm(
  sleep ~ mean_hr + sd_hr + mean_eda + mean_temp +sd_eda + mean_acc + sd_acc + people_id,
  data = bind_rows(total_data3),
  family = binomial()
)
logistic_model_eli_batch3_nopeople = glm(
  sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc,
  data = bind_rows(total_data3),
  family = binomial()
)
anova(logistic_model_eli_batch3, logistic_model_eli_batch3_nopeople,test="LRT" )
summary(logistic_model_eli_batch3)

as.data.frame(bind_rows(data_epoch)) %>%  
  group_by(people_id) %>%
  ggplot() +
  geom_boxplot(aes(y=sd_hr,x= people_id) )

as.data.frame(bind_rows(total_data3)) %>%   
  group_by(people_id) %>%
  ggplot() +
  geom_boxplot(aes(y=sd_hr,x= people_id))


