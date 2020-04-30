library(magrittr)

total_data_final_normalized = readRDS("data/total-data_final_normalized.rds")
source("R/diagnostic1_outliers.R")

outliers = readRDS("data/outliers.rds")

total_data_final_normalized = total_data_final_normalized[-outliers,]

source("R/feature_selection.R")

##### sig features
data.frame(feature=summary(backward.model)$coefficients%>%rownames(),abs_z=abs(summary(backward.model)$coefficients[,3]))%>%
  arrange(desc(abs_z))

##### ROC Curve
PRROC_obj <-
  roc.curve(
    scores.class0 = fitted(glm.model),
    weights.class0 = total_data_final_normalized$SLEEP,
    curve = TRUE
  )
plot(PRROC_obj)

##### box plot and two sample t test

data.frame(total_data_final_normalized,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) %>%
  ggplot(mapping = aes(y = sleepScore)) +
  geom_boxplot(aes(x = as.character(VE)))+
  theme_bw()+xlab("VE")

data.frame(total_data_final_normalized,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) -> sleep_data
t.test(formula = sleepScore ~ VE,
       data = sleep_data,
       alternative = "less")

data.frame(total_data_final_normalized,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) %>%
  ggplot(mapping = aes(y = sleepScore)) +
  geom_boxplot(aes(x = as.character(SEX)))+
  theme_bw()+xlab("SEX (0 for men, 1 for women)")

data.frame(total_data_final_normalized,
           sleepScore = fitted(glm.model)) %>%
  filter(SLEEP > 0.5) -> sleep_data
t.test(formula = sleepScore ~ SEX,
       data = sleep_data,
       alternative = "greater")

