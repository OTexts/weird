set.seed(1967)
library(weird)
# library(patchwork)

# Figure and chunk defaults are set by the otexts format (_extensions/)

# Set some defaults
# Colours to be viridis for continuous scales and Okabe for discrete scales
discrete_colours <- c(
  "#D55E00",
  "#0072B2",
  "#009E73",
  "#CC79A7",
  "#E69F00",
  "#56B4E9",
  "#F0E442"
)
html <- TRUE
options(
  digits = 4,
  width = 58 + html * 30,
  pillar.width = 58 + html * 30,
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  ggplot2.discrete.colour = discrete_colours,
  ggplot2.discrete.fill = discrete_colours
)
# Plot text in Fira Sans, as for headings in the book. BookMath is Fira Sans
# with maths faces added (see tex-labels.R), so theme text and text layers can
# show TeX() labels.
source(here::here("tex-labels.R"))
ggplot2::theme_update(
  text = element_text(family = "BookMath"),
  # Tick labels a little larger than the default rel(0.8), so maths in them
  # (e.g. u, s_i) isn't dwarfed by the digits; still smaller than axis titles
  axis.text = element_text(size = rel(0.9)),
  geom = element_geom(family = "BookMath")
)
# Also set on the geoms, as a complete theme such as theme_void() resets geom
ggplot2::update_geom_defaults("text", list(family = "BookMath"))
ggplot2::update_geom_defaults("label", list(family = "BookMath"))

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
wine_reviews <- fetch_wine_reviews() |> cache("wine_reviews")
air_quality <- fetch_air_quality() |> cache("air_quality")
