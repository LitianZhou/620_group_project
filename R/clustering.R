library(ggplot2)
library(dplyr)
library(PRROC)

total_data_final_normalized <-
  readRDS("data/total-data_final_normalized.rds")
total_data_final <- readRDS("data/total_data_final.rds")

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
summary(forward.model)
summary(backward.model)

glm.model=backward.model

#####sig features
data.frame(feature=summary(backward.model)$coefficients%>%rownames(),abs_z=abs(summary(backward.model)$coefficients[,3]))%>%
  arrange(desc(abs_z))

#####ROC Curve
PRROC_obj <-
  roc.curve(
    scores.class0 = fitted(glm.model),
    weights.class0 = total_data_final$SLEEP,
    curve = TRUE
  )
plot(PRROC_obj)

#####

data.frame(total_data_final,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) %>%
  ggplot(mapping = aes(y = sleepScore)) +
  geom_boxplot(aes(x = as.character(VE)))+
  theme_bw()+xlab("VE")

data.frame(total_data_final,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) -> sleep_data
t.test(formula = sleepScore ~ VE,
       data = sleep_data,
       alternative = "less")

data.frame(total_data_final,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) %>%
  ggplot(mapping = aes(y = sleepScore)) +
  geom_boxplot(aes(x = as.character(SEX)))+
  theme_bw()+xlab("SEX (0 for men, 1 for women)")

data.frame(total_data_final,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) -> sleep_data
t.test(formula = sleepScore ~ SEX,
       data = sleep_data,
       alternative = "greater")


