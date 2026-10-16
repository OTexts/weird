# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "That's Weird! Anomaly Detection using R", an open-source textbook by Rob J Hyndman, published at https://OTexts.com/weird. The book covers a probabilistic perspective on anomaly detection, from univariate and multivariate numerical data, through time series and functional data. It is built with [Quarto](https://quarto.org/) and R.

## Build Commands

```bash
make build     # Render all .qmd files to HTML, then run post-render.R (default target)
make preview   # Build, then launch a live Quarto preview in the browser
make clean     # Remove _book/, _freeze/, *_cache/, *_files/
make deploy    # rsync _book/ to production server (OTexts SSH)
```

To render a single chapter:
```bash
source .uvr/activate && quarto render univariate.qmd --to otexts-html
```
Use `--to otexts-html`: `--to html` silently drops the book's styling.

R packages are managed with [uvr](https://github.com/nbafrank/uvr), not `renv`: `uvr sync` installs `uvr.toml`/`uvr.lock` into `.uvr/`, which the Makefile activates.

## Architecture

- `*.qmd` — Chapters in Quarto Markdown. Chapters 1–13 have substantial content; 14–16 are stubs. Put chapter-level options at the top level of the front matter (e.g. `other-links:`), not under `format: html:`, which the `otexts-html` format ignores.
- `_quarto.yml` — Chapter order, bibliography (`weird.bib`), execution settings, and the `otexts-html` format.
- `_extensions/OTexts/otexts/` — The shared OTexts Quarto format ([OTexts/quarto-otexts](https://github.com/OTexts/quarto-otexts)): theme, web fonts, CSL, figure and knitr chunk defaults, and `htmlreplace.pl`. Change it in that repo, then run `quarto update OTexts/quarto-otexts`. Override figure defaults in YAML, not with `knitr::opts_chunk$set()`.
- **otexts** R package ([OTexts/otexts](https://github.com/OTexts/otexts)) — R setup shared with the other OTexts books. Change it in that repo, then run `uvr update otexts`.
- `before-each-chapter.R` — Sourced at the start of every chapter: sets the seed, loads **weird**, calls `otexts::setup_book()` (fonts, options, colour scales, ggplot2 theme, `TeX()` and `theme_void()`), and defines `discrete_colours` and the cached `wine_reviews` and `air_quality` data.
- `post-render.R` — Calls `otexts::post_render()`, which tidies the HTML with `htmlreplace.pl` and compresses the figures with pngquant (which must be installed).
- **weird** R package — The book's own package, demonstrated throughout.

## Plots

- Write maths in plot labels (axis titles, legends, annotations) with `TeX()`, e.g. `TeX("Sample size ($n$)")`. In the book `TeX()` is `otexts::tex()`, which sets maths in the KaTeX fonts; readers run the same code with `latex2exp::TeX()` (the preface tells them to), so it must work with that too:
  - write vectors as `\textbf{v}`, not `\bm{v}`, which latex2exp doesn't support;
  - wrap `TeX(c(...))` in `unname()` when it is passed directly as `labels` to a discrete scale, as ggplot2 matches named labels to breaks.
- Plot text is in the "BookMath" family (Fira Sans, which must be installed, with KaTeX maths faces), including text layers and `theme_void()`, so don't add `family = "BookMath"` to chunks. Text layers with `fontface = "bold"` or `"italic"` need `family = "Fira Sans"`, as those BookMath faces are KaTeX fonts.

## Caching

- `cache(expr, "name")` (from otexts) saves long computations as `rds/<name>.rds`. `rds/` is only for caches.
- Data sets belong in the **weird** package (as package data, or a `fetch_*()` function for large data such as `fetch_pets2006()`). The only exception is `data/halley_toms_ozone.txt` (ch1), which is published at `https://OTexts.com/weird/data/` (see `resources` in `_quarto.yml`), read from that URL, and listed under `other-links` in the chapter's front matter.
- Chunks are also cached by knitr (`*_cache/`) and frozen (`freeze: auto`), so a change to plot styling (in the otexts package or format) only reaches every figure after `make clean && make build`.

## Code Style

- R formatting follows `air.toml`: 90-character line width, 2-space indentation.
- Australian English spelling.
- `select()` and `filter()` are dplyr's (set by `setup_book()`).
