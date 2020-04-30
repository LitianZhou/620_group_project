library(ggplot2)
library(dplyr)
library(PRROC)

if(is.null(total_data_final_normalized)) 
  total_data_final_normalized <- readRDS("data/total-data_final_normalized.rds")

#####feature selection
formula.full = SLEEP ~ ACC_MEAN + ACC_SD + ACC_Q1 + ACC_Q2 + ACC_Q3 +
  TEMP_MEAN + TEMP_SD + TEMP_Q1 + TEMP_Q2 + TEMP_Q3 + HR_MEAN + HR_SD + HR_Q1 +
  HR_Q2 + HR_Q3 + EDA_MEAN + EDA_SD + EDA_Q1 + EDA_Q2 + EDA_Q3
formula.null = SLEEP ~ 1

glm(formula = formula.full,
    data = total_data_final_normalized,
    family = binomial()) -> full.model
glm(formula = formula.null,
    data = total_data_final_normalized,
    family = binomial()) -> null.model

forward.model = step(null.model, scope = list(lower = formula.null, upper = formula.full), direction = "forward", trace = 0)
backward.model = step(full.model, trace = 0)

formula(forward.model)
formula(backward.model)
# summary(forward.model)
# summary(backward.model)

if(backward.model$aic < forward.model$aic) {
  glm.model = backward.model
} else glm.model = forward.model




