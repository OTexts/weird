set.seed(1967)
library(weird)
# library(patchwork)

knitr::opts_chunk$set(
  comment = "#>",
  dev = "ragg_png",
  out.width = "100%",
  fig.align = "center",
  fig.width = 8,
  fig.asp = 0.618 # 1 / phi
)

# Set some defaults
# Colours to be viridis for continuous scales and Okabe for discrete scales
discrete_colors <- c("#D55E00", "#0072B2", "#009E73", "#CC79A7", "#E69F00", "#56B4E9", "#F0E442")
html <- TRUE
options(
  digits = 4,
  width = 58 + html * 20,
  pillar.width = 58 + html * 20,
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  ggplot2.discrete.colour = discrete_colors,
  ggplot2.discrete.fill = discrete_colors
)
ggplot2::theme_update(text = element_text(family = "Fira Sans"))

# Avoid some conflicts
conflicted::conflict_prefer("select", "dplyr")
conflicted::conflict_prefer("filter", "dplyr")

# Simple cache function
cache <- function(command, name) {
  file <- here::here(paste0("rds/", name, ".rds"))
  if (fs::file_exists(file)) {
    object <- readRDS(file)
  } else {
    object <- command
    saveRDS(object, file)
  }
  return(object)
}
