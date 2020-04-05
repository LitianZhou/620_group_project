library(ggplot2)
library(dplyr)
library(cowplot)

data_epoch <- readRDS("data/data_epoch.rds")
HR_plots = list()
for (person in names(data_epoch))
  data_epoch %>%
  bind_rows() %>%
  mutate(
    time = as.POSIXct(window_time, origin = "1970-01-01", tz = 'America/Detroit'),
    sleep = as.logical(sleep)
  ) %>%
  filter(people_id == person) %>%
  as.data.frame() %>%
  ggplot(mapping = aes(x = time, y = mean_hr)) +
  geom_line(mapping = aes(color = sleep, group = 1), size = 1.5) +
  labs(y = "HR") +
  theme_bw()+
  theme(legend.position = "none")+
  ggtitle(person) -> HR_plots[[person]]



plot_grid(
  HR_plots[[1]],
  HR_plots[[2]],
  HR_plots[[3]],
  HR_plots[[4]],
  HR_plots[[5]],
  nrow = 5,
  ncol = 1
)
