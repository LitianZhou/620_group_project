rm(list=ls())
load("/Users/liu/Desktop/Desktop/umich\ courses/biostat620/normalization1.Rdata")

fit_model = function(model_name, test_name, data = total_data1){
  testing_data = total_data1 %>% filter(people_id == test_name)
  training_data = total_data1 %>% filter(people_id != test_name)
  if (model_name == "glm") {
      model = glm(
      sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc + mean_temp + sd_temp,
      data = training_data,
      family = binomial()
    )
  }
  if (model_name == "svm") {
      model = svm(
      formula = sleep ~ mean_hr + sd_hr + mean_eda + sd_eda + mean_acc + sd_acc + mean_temp + sd_temp,
      data = training_data,
      cost = 100,
      gamma = 1
    )
  }
  truth = testing_data$sleep
  pred_prob = predict(model, testing_data, type = "response")
  pred_bin = ifelse(pred_prob>0.5,1,0)
  pred_tab <- table(pred_bin, truth)
  accuracy = confusionMatrix(pred_tab)$overall[1]
  return(list(test_truth = truth, test_pred = pred_bin, accuracy = accuracy))
}

glm_LitianZhou = fit_model(model_name = "glm", test_name = "LitianZhou", data = total_data1)
svm_LitianZhou = fit_model(model_name = "svm", test_name = "LitianZhou", data = total_data1) 
glm_BangyaoZhao = fit_model(model_name = "glm", test_name = "BangyaoZhao", data = total_data1)
svm_BangyaoZhao = fit_model(model_name = "svm", test_name = "BangyaoZhao", data = total_data1)
glm_QingzhiLiu = fit_model(model_name = "glm", test_name = "QingzhiLiu", data = total_data1)
svm_QingzhiLiu = fit_model(model_name = "svm", test_name = "QingzhiLiu", data = total_data1)
glm_NingyuanWang = fit_model(model_name = "glm", test_name = "NingyuanWang", data = total_data1)
svm_NingyuanWang = fit_model(model_name = "svm", test_name = "NingyuanWang", data = total_data1)
glm_ChenyiYu = fit_model(model_name = "glm", test_name = "ChenyiYu", data = total_data1)
svm_ChenyiYu = fit_model(model_name = "svm", test_name = "ChenyiYu", data = total_data1)

all_true = total_data1$sleep
all_glm_pred = c(glm_LitianZhou$test_pred, glm_BangyaoZhao$test_pred, glm_QingzhiLiu$test_pred, glm_NingyuanWang$test_pred, glm_ChenyiYu$test_pred)
all_svm_pred = c(svm_LitianZhou$test_pred, svm_BangyaoZhao$test_pred, svm_QingzhiLiu$test_pred, svm_NingyuanWang$test_pred, svm_ChenyiYu$test_pred)
glm_pred_tab <- table(all_glm_pred, all_true)
glm_all_accuracy = confusionMatrix(glm_pred_tab)$overall[1] #0.8870192
svm_pred_tab <- table(all_svm_pred, all_true)
svm_all_accuracy = confusionMatrix(svm_pred_tab)$overall[1] #0.8485577 

glm_svm_result = matrix(c(glm_LitianZhou$accuracy, svm_LitianZhou$accuracy, glm_BangyaoZhao$accuracy, svm_BangyaoZhao$accuracy, 
  glm_QingzhiLiu$accuracy, svm_QingzhiLiu$accuracy, glm_NingyuanWang$accuracy, svm_NingyuanWang$accuracy,
  glm_ChenyiYu$accuracy, svm_ChenyiYu$accuracy, glm_all_accuracy, svm_all_accuracy), nrow = 2)

rownames(glm_svm_result) = c("Logistic", "SVM")
colnames(glm_svm_result) = c("LitianZhou", "BangyaoZhao", "QingzhiLiu", "NingyuanWang", "ChenyiYu", "Total")
library(formattable)
formattable(as.data.frame(glm_svm_result), options(scipen = 999, digits = 2))


