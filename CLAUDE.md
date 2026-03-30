# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "That's Weird! Anomaly Detection using R", an open-source textbook by Rob J Hyndman, published at https://OTexts.com/weird. The book covers a probabilistic perspective on anomaly detection, from univariate and multivariate numerical data, through time series and functional data. It is built with [Quarto](https://quarto.org/) and R.

## Build Commands

```bash
make build     # Render all .qmd files to HTML via quarto, then post-process with htmlreplace.pl
make launch    # Open built book in browser (xdg-open _book/index.html)
make all       # build + launch (default target)
make clean     # Remove _book/, _freeze/, *_cache/, *_files/
make deploy    # rsync _book/ to production server (OTexts SSH)
```

To render and view a single chapter quickly, use Quarto directly:
```bash
quarto render 02-univariate.qmd --to html
```

R packages are managed via `renv`. After cloning, restore dependencies with:
```r
renv::restore()
```

## Architecture

### Source Files
- `*.qmd` — Book chapters in Quarto Markdown (R code + prose). Chapters 1–10 have substantial content; chapters 11–15 are stubs.
- `_quarto.yml` — Master configuration: chapter order, HTML theme (Cosmo + `otexts.scss`), bibliography (`weird.bib` with `apa-single-spaced.csl`), execution settings.
- `before-each-chapter.R` — Sourced at the start of every chapter via `_quarto.yml`. Sets random seed (1967), loads the `weird` package, configures knitr chunk defaults, sets ggplot2 themes (Okabe-Ito discrete palette, Viridis continuous), and defines a `cache()` helper that saves/loads `.rds` files from `rds/`.

### Caching
Long-running R computations use the `cache(expr, "name")` helper defined in `before-each-chapter.R`. Results are stored as `rds/<name>.rds`. Quarto's built-in chunk caching (`cache: true`) is also used; cache directories end in `_cache/` and are git-ignored.

### Post-Processing
After `quarto render`, `htmlreplace.pl` modifies the generated HTML to remove author attributions, reformat author styling, add Amazon affiliate tags to book links, and transform bibliography reference links.

### R Package: `weird`
The book's own R package (`weird`, v2.0.0+) is the primary tool demonstrated throughout. It is listed as a dependency in `renv.lock` and loaded in every chapter via `before-each-chapter.R`.

## Code Style

- R formatting follows `air.toml`: 90-character line width, 2-space indentation.
- The RStudio project (`weird.Rproj`) uses 2-space indents, UTF-8 encoding, Australian English spell-check.
- Conflict resolution: `dplyr::select` and `dplyr::filter` are explicitly preferred over any masked versions (set in `before-each-chapter.R`).
