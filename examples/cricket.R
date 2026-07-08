#remotes::install_github("robjhyndman/weird")
library(weird)

cricket_batting |>
  filter(Gender == "Men", Innings > 20) |>
  select(Innings, Runs, Average, Hundreds, Ducks) |>
  GGally::ggpairs()
