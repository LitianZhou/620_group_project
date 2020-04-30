# Outliers and influential points check:
library(ResourceSelection)
library(broom)

source('R/feature_selection.R')

plot(glm.model, which = 4, id.n = 3)
# We have three high influential points: 2450, 3584, 10381 by Cook's distance
high_inf_points = c(2450,3584,10381)
# extract model results:
model.data = augment(glm.model) %>%
  mutate(index = 1:n())

model.data %>% top_n(3, .cooksd)

ggplot(model.data, aes(index, .std.resid)) + 
  geom_point(aes(color = SLEEP), alpha = .5) +
  theme_bw()

outliers = c(high_inf_points, which(abs(model.data$.std.resid) > 3))
# We have 52 high influential observations by checking standard error of residuals
# Conlusion, we have in total 55 high influential points to delete to make our model more robust

# Goodness of fit test, almost perfect
hoslem.test(total_data_final$SLEEP, as.numeric(glm.model$fitted.values > 0.5))

saveRDS(outliers, file = "data/outliers.rds")
