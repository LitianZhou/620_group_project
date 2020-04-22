library(ggplot2)
library(dplyr)
library(PRROC)

total_data_final_normalized <-
  readRDS("data/total-data_final_normalized.rds")
total_data_final <- readRDS("data/total_data_final.rds")

glm(
  formula = SLEEP ~ ACC_MEAN + ACC_SD + TEMP_MEAN + TEMP_SD + HR_MEAN + HR_SD +
    EDA_MEAN + EDA_SD,
  data = total_data_final_normalized,
  family = binomial()
) -> glm.model

data.frame(total_data_final,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) %>%
  ggplot(mapping = aes(y = sleepScore)) +
  geom_boxplot(aes(x = as.character(VE)))

data.frame(total_data_final,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) ->sleep_data
t.test(formula=sleepScore~VE,data = sleep_data,alternative = "less")

PRROC_obj <-
  roc.curve(
    scores.class0 = fitted(glm.model),
    weights.class0 = total_data_final$SLEEP,
    curve = TRUE
  )
plot(PRROC_obj)
