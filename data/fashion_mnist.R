# Create rds/fashion.rds from the Fashion-MNIST test set (Xiao, Rasul & Vollgraf, 2017)
# https://github.com/zalandoresearch/fashion-mnist (MIT licence)
# All 1000 sneakers, plus 10 planted images from other classes of varying
# similarity to sneakers: 4 ankle boots, 3 sandals, 2 bags and 1 pair of trousers.

base <- "https://raw.githubusercontent.com/zalandoresearch/fashion-mnist/master/data/fashion/"
read_idx <- function(file) {
  con <- gzcon(url(paste0(base, file), "rb"))
  on.exit(close(con))
  magic <- readBin(con, "integer", n = 1, size = 4, endian = "big")
  ndim <- magic %% 256
  dims <- readBin(con, "integer", n = ndim, size = 4, endian = "big")
  x <- readBin(con, "integer", n = prod(dims), size = 1, signed = FALSE)
  if (ndim == 3) matrix(x, nrow = dims[1], byrow = TRUE) else x
}
pixels <- read_idx("t10k-images-idx3-ubyte.gz")
label <- read_idx("t10k-labels-idx1-ubyte.gz")
classes <- c(
  "T-shirt", "Trousers", "Pullover", "Dress", "Coat",
  "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot"
)

set.seed(1967)
planted <- c(
  sample(which(label == 9), 4),
  sample(which(label == 5), 3),
  sample(which(label == 8), 2),
  sample(which(label == 1), 1)
)
idx <- c(which(label == 7), planted)
fashion <- tibble::tibble(
  id = idx,
  label = factor(classes[label[idx] + 1], levels = classes),
  planted = idx %in% planted,
  pixels = pixels[idx, ]
)
saveRDS(fashion, here::here("rds/fashion.rds"))
