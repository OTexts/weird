# Post-process the HTML files from this render
# (run by Quarto via project: post-render in _quarto.yml)
files <- strsplit(Sys.getenv("QUARTO_PROJECT_OUTPUT_FILES"), "\n")[[1]]
files <- files[endsWith(files, ".html")]
if (length(files) > 0) {
  status <- system2("perl", c("-i", "htmlreplace.pl", shQuote(files)))
  if (status != 0) stop("htmlreplace.pl failed")

  # Reduce figures to 256 colours; pngquant leaves a file unchanged (exit 98/99)
  # if the result would be larger or below the quality floor
  fig_dirs <- file.path(sub("\\.html$", "_files", files), "figure-html")
  pngs <- list.files(fig_dirs, pattern = "\\.png$", full.names = TRUE)
  status <- unlist(parallel::mclapply(
    pngs,
    function(png) {
      system2(
        "pngquant",
        c("--force --ext .png --skip-if-larger --quality=80-100", shQuote(png))
      )
    },
    mc.cores = 8
  ))
  if (any(!status %in% c(0, 98, 99))) stop("pngquant failed")
}
