# Lessons

## 2026-10-01

- **Notation must earn its place.** When introducing notation (e.g. adjacency matrix $\bm{A}$), use it straight away to define or explain the chapter's ideas (degree, betweenness, density, ...). Never add a notation paragraph that nothing later refers to.
- **Don't impose a model the data clearly violate.** Before drawing model-based summaries (Normal HDR ellipses, chi-squared cutoffs) on real data, check that the data plausibly follow that model. For illustrating a method's assumptions (e.g. MCD vs sample covariance), prefer simulated data where the true distribution is known, so the summary is valid and can be compared with the truth.
- **Prerequisite reasoning must be stated.** When a step relies on a result (e.g. "we might expect pi = 0.001"), state why (uniform surprisal probabilities under a correct forecast distribution, via the PIT) and cross-reference where it is proved.
- **Define every symbol and value used.** If a formula uses a quantity that varies (e.g. $M_t$ series per month), say what it is and give its values; don't leave an implicit constant.
- **Check data quirks before interpreting results.** E.g. tnet's UCI data contain one self-loop per node; PBS data record the safety-net reset in February. Inspect the raw data before writing explanations.
- **Citations:** pandoc locators go after the key with a recognised label: `[@fpp3, Ch. 4]`, or narrative `@fpp3 [Ch. 8]`. `ch4` without a label renders as "pch4".

## 2026-10-02

- **Respect the chapter's order of ideas.** Before adding a result to a section, check that every concept it uses is already introduced at that point (grep for the concept's own section). If it isn't, put the result where the concept is defined (e.g. the conditional MVN formula belongs in sec-conditional, not in the MVN subsection that precedes it); a forward `@sec-` reference doesn't fix that.
- **Test a causal explanation before writing it.** Don't attribute a result to a mechanism (e.g. stray's [0,1] rescaling making rain hours stand out) without checking the counterfactual (rerun without it). Here the data were already z-scored and rainfall's skewness alone explained the result; rescaling actually reduced rainfall's weight.
- **Don't measure extremeness in SDs for skewed data.** For heavily skewed variables (e.g. hourly rainfall, mostly zero), describe how extreme a value is in the variable's own units against a robust reference (median of non-zero values, counts), not "k standard deviations above the mean".
- **Check what is actually new before framing a method's contribution.** When rewriting a method's results, compare its top-ranked observations with every other method's output in the chapter; the observations it shares with them are not its contribution. (Ch 9 stray: the rain hours were already top for od/iso; the genuinely new find was the 29–30 May night-time NO2 run.)
- **Check claims against exactly what the chapter prints.** Derive wording from the same top-n, seed and environment as the rendered chunk (e.g. I read a top 15 and claimed five 31 May hours were in a top 10 that held three). The guard chunk caught it; write the guard before the prose.
- **Check randomised results across seeds before describing them.** ROBPCA (and isolation forests, adjOutlyingness) use random subsets/directions. Before commenting on a specific classification, refit over several seeds; describe borderline cases as borderline, and have guards check the figure's own fitted objects rather than refitting (a refit uses a different RNG state).
- **Motivate ideas where they are introduced, not in a round-up.** In a background chapter, put a one-sentence forward link ("this is used in Chapter X for ...") in the section that introduces each tool. Don't tack a list of forward links onto the end of the chapter, least of all inside an unrelated final section.
- **Explain a model's anomalies in the model's own terms.** When describing why an observation is anomalous under a fitted model, condition on all the model's covariates (e.g. RPI *and* year of debut), not a convenient subset, and don't add comparisons that make a model-flagged anomaly look like a mistake. If a claim is only marginally off, prefer a minimal edit over a rewrite.
- **Values cited in prose must be visible to the reader.** When a paragraph quotes a number from a printed table, check the rendered output actually shows that column (tibbles truncate wide output with "ℹ n more variables"); select the relevant columns, and say where the number appears.

- **Explain a result in proportion to its place in the chapter.** When adding an explanation for a surprising result (e.g. the gap test's 68 Old Faithful flags), give the cause in one sentence. Don't add a supporting quantitative aside ("only a few hundredths of a second") that the reader can't check without a derivation; either show the working or leave it out.

## 2026-10-03

- **Don't use a term before the book defines it.** Before inserting a book-specific term (e.g. "surprisal probability", defined in ch7) into an earlier chapter, grep for where it is defined; if that is later, describe the idea in plain words and keep the forward `@sec-` reference. Consistency with later chapters' terminology doesn't justify a forward use.
- **Fix an author's intuitive explanation; don't replace it with a derivation.** When an explanation is wrong only in detail (e.g. "tails" for Uniform data), keep its intuition and correct the faulty part (ch3: "a point is near the centre only if all coordinates are near zero"), rather than swapping in a more technical argument (mean squared distance $m/3$).

## 2026-10-06

- **Verify a styling change by looking at it.** Reading the compiled CSS for one expected rule (`strong{font-weight:bolder}`) missed a later rule that overrode it (Quarto's `code{font-weight:$font-weight-monospace-inline}`). For any visual change, render the page and take a screenshot (headless `google-chrome --screenshot`) before calling it done.

## 2026-10-07

- **Sections follow the reader's ideas, not the build steps.** One approach (e.g. PCA of images: fit, eigen-images, then score/orthogonal distances and other methods on the scores) belongs in one section, parallel to the other approaches. Don't turn the steps of a plan into separate sections; check that sibling sections are parallel units (ch13: the PCA strategy was split over two sections while the features strategy had one).
- **Use a method's outputs the way the book frames them.** Before describing what a cutoff or score "does" in a later chapter, reread how the defining chapter presents it. Ch9's SD/OD cutoffs are 97.5% Normal-model reference lines that sort points into the four outlier-map types (about 5% outside by chance), not anomaly classifiers; ch13 wrongly said ROBPCA "classifies 179 images as anomalous".
- **Say exactly which step assumes normality.** A fixed threshold on (robust) z-scores assumes nothing; only a threshold *derived from* Normal tail probabilities does. Heavy tails mean the threshold must come from the observed distribution, not that thresholding fails. And describe a computation as done if the code does it ("we compute"), never as hypothetical ("we could") followed by doing it anyway (ch13 pixel residuals).
- **Don't argue against an assumption nobody made.** A section that sets up a Normal threshold only to knock it down (ch13 pixel z-scores) adds nothing; cut it and spend the space on the analysis the section promised.
- **Deliver what a section's opening promises, using the previous section's results.** Ch13 "Anomalous pixels" promised *where* things happen but showed six frames picked before any analysis; it now shows residual maps for the frames the orthogonal distances flagged (plus a contrast frame).
- **Only describe what the figure visibly shows.** Before writing "there are also fainter X" about a figure, look at the rendered figure at its actual scale. Ch13's reflection residuals were invisible under the capped linear grey scale, and even a sqrt scale showed only a halo that could be reflection, shadow or edge blur; the sentence was cut.
- **No royal "we".** "We" means author and reader together ("we can see", steps of a worked analysis). Announcements, definitions, the author's choices and data preparation done off the page take no "we" ("This chapter describes", "This is called", "The data used here are"). The deslop skill's advice to turn passive voice into "we" doesn't apply to these (ch13: I rewrote "Both strategies are demonstrated" as "We demonstrate both strategies").

## 2026-10-07 (data)

- **Grep the whole project before calling a file unused.** I called `rds/air_quality.rds` and `rds/wine_reviews.rds` stale after grepping only `*.qmd`; both are `cache()`d in `before-each-chapter.R`. Search every source file (`.qmd`, `.R`, `_quarto.yml`, Makefile), and for `cache()` files search for the name in quotes, not the filename.

## 2026-10-08

- **A justification for a choice gets one sentence.** When explaining why the book deviates from a convention (e.g. MAD rather than $Q_n$ in the ch4 gap test), state the choice and its reason in a single sentence; don't add the mechanism behind the reason. This is the same rule as "explain a result in proportion to its place" (2026-10-02), which I broke by writing three sentences.

## 2026-10-09

- **Confirm a rebuild actually happened before reading its output.** `make build` only reruns when a listed dependency changes; `goatcounter.html` wasn't one, so a "rebuild" after editing it silently served stale `_book/` files. Check that the `quarto render` line appears in make's output (or render directly) before drawing conclusions from `_book/`.
- **Say which pages a fix is for.** The GoatCounter `https://` change was needed only for the 404 page (Quarto prefixes every relative URL there with `/weird/`, mangling `//host/...`); the user reasonably read it as a fix for all pages, which were already fine. Lead with where the problem actually occurs.
- **After renaming source files, check every output path, not just page links.** Renaming `07-density.qmd` etc. left `_freeze/*/execute-results/html.json` pointing at `07-density_files/...`, so 12 chapters lost their figures; my check only grepped for links to old `.html` names. Verify that every `src=` in `_book/*.html` resolves to an existing file, and delete stale `_freeze` entries after a rename.
- **Only report an action as done after doing it.** I told the user I'd added a lesson to this file when I hadn't written it.

## 2026-10-13

- **Check that a problem exists in each target before porting its fix.** I added a TOC inline-code rule to all four books after seeing the box only in fpppy; fpp3, weird and unbelievable didn't need it, because Quarto already strips the box from plain `<code>` in the TOC and only fpppy's language-tagged `code.sourceCode` escapes that. Before copying a fix across projects, confirm the symptom in each one (render it, or check the computed style), and scope the rule to the cause.
- **Compare whole config files, not one section.** Quarto options can be set at the top level of `_quarto.yml` as well as under `format: html:`. I diffed only the `format:` sections of weird and fpp3 and wrongly reported that fpp3 lacked `toc-title` and KaTeX (both are top-level there). Check the effective setting in the built HTML (e.g. `id="toc-title"`, the math script loaded) before claiming a config difference.
- **Don't filter properties out of a style diff.** Porting the theme to fpppy, I excluded `border-left-color` from the computed-style comparison as noise and missed that the code-block border had changed from pale grey to near-black (Quarto ignores a non-colour `$code-block-border-left` such as `3px solid $x` and falls back to `$table-border-color`). Compare every property, and look at a screenshot of each changed element type.

## 2026-10-16

- **Pitch results at the book's level, not the paper's.** The book is for undergraduates; talks and papers are for academic statisticians. When porting a result from a talk or paper (e.g. the GPD-tail theorem for surprisals), give the intuition, an example per case, and what it means in practice; leave formal conditions (moment conditions, limits, normalising functions) to the citation.
- **Reread the surrounding sentences after adding a qualified explanation.** I added a hedged account of why surprisals have GPD tails ("in most cases") but left the sentence just before it claiming they "will still" follow a GPD. A new paragraph that qualifies a claim must also fix the unqualified version next to it.
- **Check what follows an insertion still makes sense.** Adding @fig-gpd-approx between the GPD explanation and a paragraph that pointed back to it ("give the precise conditions") left that paragraph with nothing to refer to. After inserting a block, reread the paragraph after it and move any back-reference to sit next to what it refers to.
- **A drop-in replacement must match the original's output exactly, attributes included.** My `tex()` returned a named expression where `latex2exp::TeX()` returns an unnamed one; ggplot2 4 matches named scale labels to breaks by name, so every legend using `tex()` silently fell back to the raw factor levels. Before swapping a function in book-wide, compare `str()`/`attributes()` of old and new output on the actual call sites, and diff the figures, not just the labels in isolation.
- **When fixing a bug in a value's attributes, trace every place the attribute can come from.** I removed `setNames()` from `tex()` but `latex2exp::TeX(output = "character")` also returns names, which `lapply()` carried through; the linetype legend in ch2 kept showing raw breaks. Fix at the source (`unname()` the input) and add an assertion (`is.null(names(tex(...)))`) rather than removing one visible cause.
- **Never label an unnumbered section.** `_quarto.yml` has `number-depth: 2`, so `###` headings have no number, but `@sec-` references to them still render as "Section 7.2.2", a number the reader can't find. Cross-reference only `#` and `##` headings: cite the enclosing `##` section, or name the `###` heading in words ("as explained earlier"). Check a heading's level before adding `{#sec-...}`.
