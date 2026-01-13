vr_complex <- function(X, delta) {
  colnames(X)[1:2] <- c("x", "y")
  p <- ggplot(X) +
    ggforce::geom_circle(
      aes(x0 = x, y0 = y, r = delta / 2),
      fill = "#56B4E9",
      color = "transparent",
      alpha = 0.3
    )
  # Draw lines between all pairs of points less than delta apart
  d <- dist(X[, 1:2]) |>
    as.matrix() |>
    as.data.frame() |>
    mutate(row = 1:NROW(X)) |>
    tidyr::pivot_longer(1:NROW(X), names_to = "col", values_to = "d") |>
    dplyr::filter(row < col, d < delta)
  d <- d |>
    mutate(
      x = X[row, ]$x,
      y = X[row, ]$y,
      xend = X[col, ]$x,
      yend = X[col, ]$y
    )
  p +
    geom_segment(data = d, aes(x = x, y = y, xend = xend, yend = yend)) +
    geom_point(data = X, aes(x = x, y = y), size = 2, col = "#b14c14")
}
