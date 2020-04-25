library(openxlsx)
library(ggplot2)
library(ggpubr)
library(dplyr)
library(ResourceSelection)

dataset <- read.csv("shooting_data.csv")
glimpse(dataset)

county_data <- dataset %>%
    group_by(city_or_county) %>%
    summarise(n_incidents_by_county = n(), n_killed_by_county = sum(n_killed))

hist(county_data$n_killed_by_county)

hist(dataset$victim_age)

victim_age <- dataset %>%
    group_by(victim_age) %>%
    summarise(freq = n(), n_killed_by_vicage = mean(n_killed))

ggplot(victim_age, aes(x = victim_age)) +
    geom_smooth(aes(y = n_killed_by_vicage), method = "loess", se = FALSE)

hist(dataset$perp_age)

perp_age <- dataset %>%
    group_by(perp_age) %>%
    summarise(n_killed_by_vicage = mean(n_killed))

ggplot(perp_age, aes(x = perp_age)) +
    geom_smooth(aes(y = n_killed_by_vicage), method = "loess", se = FALSE)

vic_agecat = ifelse(dataset$victim_age < 20, 0, ifelse(dataset$victim_age <40, 1, 2))
perp_agecat = ifelse(dataset$perp_age < 20, 0, ifelse(dataset$perp_age <40, 1, 2))

dataset[,22] <- dataset$victim_age
dataset[,23] <- dataset$perp_age
dataset[,19] <- vic_agecat
dataset[,21] <- vic_agecat

table = list(NA)
chisq = rep(NA, 15)
for(i in 7:21){
    table[[i-6]] <- table(dataset[,i], dataset$n_killed, dnn = c(colnames(dataset)[i], "n_killed"))
    ifelse(dim(table[[i-6]])[1] > 1, chisq[[i-6]] <- chisq.test(dataset[,i], dataset$n_killed)$p.value, chisq[[i-6]] <- NA)
}

glm(dataset$n_killed ~ dataset$robbery, family = binomial)
glm(dataset$n_killed ~ dataset$robbery + dataset$defensive, family = binomial)
model <- glm(dataset$n_killed ~ dataset$robbery + dataset$defensive + dataset$hate, family = binomial)
1 - pchisq(model$null.deviance - model$deviance, 4)
hoslem.test(dataset$n_killed, fitted(model), g = 10)

nothing <- glm(dataset$n_killed ~ 1, family = binomial)
fullmod <- glm(dataset$n_killed ~ dataset$robbery + dataset$police + dataset$defensive + dataset$school + dataset$gang + dataset$social + dataset$roadrage + dataset$hate + dataset$drug + dataset$workplace + dataset$dv + dataset$victim_fem + dataset$victim_age + dataset$perp_fem + dataset$perp_age, family = binomial)
forwards = step(nothing, scope = list(lower = formula(nothing), upper = formula(fullmod)), direction = "forward")
backwards = step(fullmod, trace = 0)
formula(backwards)
