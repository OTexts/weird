# Create rds/pets2006.rds from the CDnet 2014 PETS2006 video (Wang et al., 2014)
# http://changedetection.net (baseline category), downloaded via
# https://www.kaggle.com/datasets/maamri95/cdnet2014
# Usage: Rscript data/pets2006.R <path to dataset/baseline/PETS2006>
# Frames 300-1200 (those with ground truth), every third frame, converted to greyscale
# and downsampled from 720 x 576 to 120 x 96 by averaging 6 x 6 blocks.

path <- commandArgs(trailingOnly = TRUE)[1]
frames <- seq(300, 1200, by = 3)
block <- 6

# Average non-overlapping block x block cells of a matrix
downsample <- function(x) {
  nr <- nrow(x) / block
  nc <- ncol(x) / block
  x <- array(x, c(block, nr, block, nc))
  apply(x, c(2, 4), mean)
}
read_frame <- function(i) {
  img <- jpeg::readJPEG(file.path(path, "input", sprintf("in%06d.jpg", i)))
  grey <- 0.299 * img[, , 1] + 0.587 * img[, , 2] + 0.114 * img[, , 3]
  c(round(255 * downsample(grey)))
}
# Ground truth: 255 = moving object, 0 = static, 50 = shadow, 170 = unknown
read_truth <- function(i) {
  gt <- png::readPNG(file.path(path, "groundtruth", sprintf("gt%06d.png", i)))
  c(round(block^2 * downsample(round(255 * gt) == 255)))
}

pets2006 <- list(
  frame = frames,
  nrow = 576 / block,
  ncol = 720 / block,
  # One row per frame; pixels stored column by column (as in c(matrix))
  pixels = t(sapply(frames, read_frame)),
  # Number of ground-truth moving-object pixels in each 6 x 6 block (0 to 36)
  truth = t(sapply(frames, read_truth))
)
storage.mode(pets2006$pixels) <- "integer"
storage.mode(pets2006$truth) <- "integer"
saveRDS(pets2006, here::here("rds/pets2006.rds"))
