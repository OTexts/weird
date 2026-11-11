# Post-process the files from this render (run by Quarto via project:
# post-render in _quarto.yml): tidy the HTML with the otexts format's
# htmlreplace.pl, and compress the figures with pngquant
otexts::post_render()

# Copy the grand tour video here rather than listing it under `resources`, as Quarto
# expands `resources` before chunks run and so misses a video made in the same render
video <- "videos/highdim-grand-tour.mp4"
if (file.exists(video)) {
  output_dir <- file.path(Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR"), "videos")
  dir.create(output_dir, showWarnings = FALSE)
  stopifnot(file.copy(video, output_dir, overwrite = TRUE))
} else if (Sys.getenv("QUARTO_PROJECT_RENDER_ALL") == "1") {
  stop(video, " is missing: delete highdim_cache and _freeze/highdim, then render again")
}
