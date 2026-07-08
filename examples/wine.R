#remotes::install_github("robjhyndman/weird")
library(weird)

wine_reviews |>
  filter(variety %in% c("Shiraz", "Syrah")) |>
  select(points, price) |>
  ggplot(aes(y = price, x = points)) +
  geom_jitter(height = 0, alpha = 0.4) +
  scale_y_log10()
