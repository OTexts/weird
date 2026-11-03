# That's weird: Anomaly and outlier detection using R

Source files for the open-source textbook by Rob J Hyndman, published at <https://OTexts.com/weird>.

## Building the book

### Dependencies

- [R](https://www.r-project.org/) 4.6.1 or later
- [Quarto](https://quarto.org/) (tested with 1.10)
- [uvr](https://github.com/nbafrank/uvr), to install the R packages (see below)
- [Fira Sans](https://github.com/mozilla/Fira), installed as a system font: figures use it via `ragg`
- `make`, `bash` and `perl`, to run the build and post-process the HTML
- [pngquant](https://pngquant.org/), to reduce figures to 256 colours after rendering
- [ffmpeg](https://ffmpeg.org/), to encode the grand tour video in Chapter 9 (only needed when that chapter is re-executed)
- `rsync` and `ssh`, for `make deploy` only

If R packages are compiled from source, some need system libraries, such as libcurl, OpenSSL, libxml2, FreeType, HarfBuzz, FriBidi and GLPK.

The web fonts used on the site (Libron, Fira Sans and Hack) come with the [OTexts Quarto format](https://github.com/OTexts/quarto-otexts) in `_extensions/`, so they need not be installed.

### R packages (uvr)

Packages are listed in `uvr.toml` and pinned in `uvr.lock`. They install into `.uvr/library`, which `.Rprofile` puts on the library path.

```bash
uvr sync              # install from uvr.lock
uvr add <pkg>         # add a package
uvr update            # update packages and the lockfile
uvr doctor            # check which R is active
```

Any R satisfying `r_version` in `uvr.toml` will do. `uvr sync` must build packages with the same R that Quarto runs (the first R on your PATH), or compiled packages such as igraph may fail to load. If you have more than one R installed, run `uvr r pin <version>` with the version Quarto uses. This writes `.r-version`, which is git-ignored because each machine pins its own R. Re-pin and run `uvr sync` after upgrading R. If a compiled package still fails, rebuild from source with `UVR_NO_BINARY=1 uvr sync`.

### Quarto

```bash
quarto render --to otexts-html            # whole book, into _book/
quarto render intro.qmd --to otexts-html  # one chapter
quarto preview                            # live preview
```

Always use `--to otexts-html`; plain `--to html` drops the OTexts styling. The post-render script (`htmlreplace.pl`, pngquant) runs automatically.

### Makefile

| Target          | Does                                                          |
|-----------------|---------------------------------------------------------------|
| `make build`    | Full render (default). Skips if no sources changed since last build |
| `make preview`  | `quarto preview`                                              |
| `make update`   | `uvr update && uvr sync` (reinstalling weird)                 |
| `make deploy`   | Build, then rsync `_book/` to otexts.com/weird                |
| `make clean`    | Remove `_book`, `_freeze`, `*_cache`, `*_files`               |

Run `make clean` after updating R packages or data, as chunk output is cached in `_freeze/` and `<chapter>_cache/`.
