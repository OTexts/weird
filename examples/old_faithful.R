#remotes::install_github("robjhyndman/weird")
library(weird)

oldfaithful |>
  ggplot(aes(x = duration)) +
  geom_boxplot()

oldfaithful |>
  ggplot(aes(x = duration)) +
  geom_density() +
  geom_rug()

oldfaithful |>
  ggplot(aes(x = duration, y = waiting)) +
  geom_point(alpha = 0.2) +
  geom_smooth()
