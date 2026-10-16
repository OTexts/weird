set.seed(1967)
library(weird)
# library(patchwork)

# Figure and chunk defaults are set by the otexts format (_extensions/).
# The rest of the setup shared by the OTexts books is in the otexts package:
# plot fonts (BookMath for TeX() labels), printing options, viridis and
# Okabe-Ito colour scales, the ggplot2 theme, dplyr preferred for select() and
# filter(), and TeX() and theme_void() defined so chunks can call them.
library(otexts)
setup_book()

# The Okabe-Ito colours of the discrete scales, used by some chunks
discrete_colours <- book_colours()

wine_reviews <- fetch_wine_reviews() |> cache("wine_reviews")
air_quality <- fetch_air_quality() |> cache("air_quality")
