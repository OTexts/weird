# That's weird

### Anomaly and outlier detection using R

## Building the book

### Dependencies

- [R](https://www.r-project.org/) (version 4.6.1 is recorded in `uvr.lock`)
- [Quarto](https://quarto.org/) (tested with 1.10)
- [uvr](https://github.com/nbafrank/uvr), to install the R packages (see below)
- [Fira Sans](https://github.com/mozilla/Fira), installed as a system font: figures use it via `ragg`
- `make`, `bash` and `perl`, to run the build and post-process the HTML
- [pngquant](https://pngquant.org/), to reduce figures to 256 colours after rendering
- [ffmpeg](https://ffmpeg.org/), to encode the grand tour video in Chapter 9 (only needed when that chapter is re-executed)
- `rsync` and `ssh`, for `make deploy` only

If R packages are compiled from source, some need system libraries, such as libcurl, OpenSSL, libxml2, FreeType, HarfBuzz, FriBidi and GLPK.

The web fonts used on the site (Libron, Fira Sans and Hack) are included in `fonts/`, so they need not be installed.

### Setting up

R package dependencies are managed with [uvr](https://github.com/nbafrank/uvr), a fast package manager for R.
Install it, then set up the project environment:

```bash
uvr sync
```

This reads `uvr.toml`/`uvr.lock` and installs the required packages into a project-local environment at `.uvr/`.

Once the environment is set up, build the book with `make`:

```bash
make build     # Render all chapters to HTML (default target)
make preview   # Build, then launch a live preview in the browser
make clean     # Remove build artifacts
```
