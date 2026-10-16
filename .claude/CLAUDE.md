# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "That's Weird! Anomaly Detection using R", an open-source textbook by Rob J Hyndman, published at https://OTexts.com/weird. The book covers a probabilistic perspective on anomaly detection, from univariate and multivariate numerical data, through time series and functional data. It is built with [Quarto](https://quarto.org/) and R.

## Build Commands

```bash
make build     # Render all .qmd files to HTML via quarto, then post-process with htmlreplace.pl (default target)
make preview   # Build, then launch a live Quarto preview in the browser
make clean     # Remove _book/, _freeze/, *_cache/, *_files/
make deploy    # rsync _book/ to production server (OTexts SSH)
```

To render and view a single chapter quickly, use Quarto directly:
```bash
source .uvr/activate && quarto render univariate.qmd --to html
```

R packages are managed via [uvr](https://github.com/nbafrank/uvr), not `renv`. After cloning, restore dependencies with:
```bash
uvr sync
```
This reads `uvr.toml`/`uvr.lock` and installs packages into a project-local environment at `.uvr/`, which the Makefile sources automatically via `.uvr/activate`.

## Architecture

### Source Files
- `*.qmd` — Book chapters in Quarto Markdown (R code + prose). Chapters 1–13 have substantial content; chapters 14–16 are stubs.
- `_quarto.yml` — Master configuration: chapter order, HTML theme (Cosmo + `otexts.scss`), bibliography (`weird.bib` with `apa-single-spaced.csl`), execution settings.
- `before-each-chapter.R` — Sourced at the start of every chapter via `_quarto.yml`. Sets random seed (1967), loads the `weird` package, configures knitr chunk defaults, sets ggplot2 themes (Okabe-Ito discrete palette, Viridis continuous), and defines a `cache()` helper that saves/loads `.rds` files from `rds/`.
- `tex-labels.R` — Sourced by `before-each-chapter.R`. Registers the "BookMath" font family (Fira Sans for text, KaTeX fonts for maths) and defines `tex()`, a restyled `latex2exp::TeX()` so maths in plots matches the KaTeX maths in the text. It also sets `TeX <- tex`, so chunks call `TeX()` and readers can run the same code with `library(latex2exp)` (the preface tells them to). Keep the visible code working with plain `latex2exp::TeX()`: write vectors as `\textbf{v}` (not `\bm{v}`, which latex2exp doesn't support; `tex()` sets `\textbf` in bold italic), and wrap `TeX(c(...))` in `unname()` when it is passed directly as `labels` to a discrete scale (latex2exp returns names, which ggplot2 4 matches to breaks). Theme text and text layers default to BookMath (`element_geom(family = )`, plus `update_geom_defaults()` for text and label, which survives `theme_void()`), so don't add `family = "BookMath"` to chunks; text layers with `fontface = "bold"` or `"italic"` need `family = "Fira Sans"`, as those BookMath faces are KaTeX fonts. Needs Fira Sans installed; the KaTeX fonts are copies in `plot-fonts/`, scaled up by 1.2 so their x-height matches Fira Sans (regenerate with `plot-fonts/make_plot_fonts.py`). Write maths in plot labels (axis titles, legends, annotations) with `TeX()`, e.g. `TeX("Sample size ($n$)")`, not as plain text.

### Caching
Long-running R computations use the `cache(expr, "name")` helper defined in `before-each-chapter.R`. Results are stored as `rds/<name>.rds`. `rds/` is only for caches. Data sets used in the book belong in the `weird` package (as package data, or a `fetch_*()` function for large data such as `fetch_pets2006()`). The only exception is `data/halley_toms_ozone.txt` (ch1), which is published at `https://OTexts.com/weird/data/` (see `resources` in `_quarto.yml`), read from that URL (not via `here::here()`), and listed under `other-links` in the chapter's YAML front matter so it appears in the sidebar. Quarto's built-in chunk caching (`cache: true`) is also used; cache directories end in `_cache/` and are git-ignored. With `freeze: auto` as well, a change to plot styling in `before-each-chapter.R` or `tex-labels.R` only reaches every figure after `make clean && make build`.

### Post-Processing
After `quarto render`, `htmlreplace.pl` modifies the generated HTML to remove author attributions, reformat author styling, add Amazon affiliate tags to book links, and transform bibliography reference links.

### R Package: `weird`
The book's own R package (`weird`, v2.0.0+) is the primary tool demonstrated throughout. It is listed as a dependency in `uvr.toml`/`uvr.lock` and loaded in every chapter via `before-each-chapter.R`.

## Code Style

- R formatting follows `air.toml`: 90-character line width, 2-space indentation.
- The RStudio project (`weird.Rproj`) uses 2-space indents, UTF-8 encoding, Australian English spell-check.
- Conflict resolution: `dplyr::select` and `dplyr::filter` are explicitly preferred over any masked versions (set in `before-each-chapter.R`).
