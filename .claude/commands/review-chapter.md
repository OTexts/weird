# Review Chapter

Review a book chapter (.qmd file) of "That's Weird! Anomaly Detection using R" for notational consistency, accuracy, and clarity. The target audience is 3rd year undergraduates studying statistics at Australian universities.

## Instructions

The user will either name a chapter (e.g. "chapter 3" or "03-multivariate.qmd") or you should infer it from context (e.g. the currently open file). If the chapter is ambiguous, ask.

Read the entire chapter in sections using offset/limit, then apply all fixes directly to the file. Do not just report issues — fix them. The user can choose to discard them via sublime merge if needed.

Also run the `deslop` skill over the chapter's prose as part of this review, and apply its fixes directly alongside the others.

Also update this skill to take account of any new issues you find when reviewing the chapter.

## What to check

**Notation consistency**
- Math symbols used consistently throughout (e.g. `\Pr` vs `\text{Pr}`, `\le` vs `\leq`, `\ge` vs `\geq`, `\bm{}` for vectors/matrices). The book uses `\le` and `\ge` (not `\leq`/`\geq`).
- Parameter lists in pdfs match the parameterisation stated in the text
- The sample size of the data is always $n$.
- The data dimension is $m$ consistently throughout the book. The BACON algorithm's initial-subset-size parameter uses $s$ in both `06-distance.qmd` and `08-regression.qmd`, to avoid clashing with $m$ = dimension, even though `robustX::BACON()`'s R argument for this value is literally called `m`. Where a code chunk exposes that `m` argument, there should be a short bridging sentence just before the chunk noting that it sets $s$ (e.g. "This initial size $s$ is set using the `m` argument of `robustX::BACON()` below.") — check this sentence is present rather than re-deriving whether $m$ or $s$ is "more correct".
- For regression problems, use $p$ for the number of predictors (including the intercept where included).
- Bold notation applied consistently to vectors and matrices
- Matrix transposes use `^\intercal`, not `'` or `^T` or `^\prime`.
- Subscript/superscript placement correct (e.g. `$\bm{S}^*$` not `$\bm{S^*}$`)
- Same symbol not used for two different things in the same chapter.
- Within a chapter, a quantity should use one consistent symbol.
- Distribution names use upright (non-italic) font: `N(0,1)` not `$N(0,1)$`. When parameters contain maths symbols, put only the parameters in maths: `N$(\mu, \sigma^2)$` or `$\text{N}(\mu, \sigma^2)$`.
- Compound expressions used as adjectives/quantifiers should be parenthesised in maths: `$(1-\beta)$ sample quantile`, not `$1-\beta$ sample quantile`.
- Two-author eponyms (named after two people) use an en-dash, not a hyphen, and should be consistent throughout: `Stahel--Donoho`, not `Stahel-Donoho`. (One-word-each compound modifiers like `projection-based` keep the hyphen.)
- The source uses Pandoc dash markup, not literal Unicode dash characters: `--` for en-dashes (eponyms, number ranges) and `---` for parenthetical em-dashes. Replace any literal `–` or `—` with `--`/`---`. This applies to plain-prose year/number ranges too, e.g. a bulleted list entry `1914-1918: World War I` should be `1914--1918: World War I` — grep for `[0-9]-[0-9]` outside code chunks.
- Conditioning bars in density/probability notation should use `\mid` (not a raw `|`) for correct spacing — check this is consistent *within* the chapter; a chapter that uses `\mid` in some formulas and `|` in others (e.g. $f(y\mid x)$ vs $f(y|x)$) should be normalised to `\mid` throughout, matching the book-wide preference for `\mid` where conditioning is written out repeatedly.
- Chapter cross-references in square brackets, e.g. `[Ch 8, @fpp3]`, should be formatted consistently (`Ch 8` with a space, not `Ch8`) if used more than once in the same chapter.
- Vector ↔ matrix notation: observations are column vectors $\bm{y}_i$ but are stored as *rows* of the data matrix $\bm{Y}$ (so the $i$th row is $\bm{y}_i^\intercal$). This flips multiplication order between the single-observation form ($\bm{w}_i = \bm{A}^\intercal\bm{y}_i$) and the matrix form ($\bm{W} = \bm{Y}\bm{A}$). Make the bridge explicit (transpose the vector equation and stack the rows), and write the single-observation projection as $\bm{A}^\intercal\bm{y}_i$ / $\bm{a}^\intercal\bm{y}_i$ rather than $\bm{y}_i^\intercal\bm{a}$ so it matches the general form.
- Watch for a letter reused for two unrelated quantities within the same chapter even when each usage is individually standard in its own sub-topic — e.g. $J$ used earlier for "number of basis functions" and later reused for "number of curves in a band-depth band" (a legitimate notation in the depth literature, but a collision within this chapter). Rename the second usage to a free letter (check which single letters already appear in the chapter's inline math before picking one).
- A general definition given early must stay literally true for every specific case introduced later. E.g. if $b_0(x)$ is first introduced as "a constant function" (constant in $x$) and a later paragraph sets "$b_0(x)$ is the mean function" (which varies with $x$), the two statements contradict each other — fix the general definition (e.g. "a fixed function common to every observation, analogous to an intercept") rather than the specific one.
- A general claim followed immediately by narrower examples should not overclaim beyond what those examples support — e.g. don't assert a basis "spans the space of all functions" right before giving two examples that are each restricted to a narrower class (periodic functions, smooth functions).
- A displayed minimisation/objective equation that is supposed to summarise a fit over a whole sample of $n$ curves/observations needs the sum over $i$ (and, for functional data, the integral over the domain) — an expression like $[y_i(x) - b_0(x) - \beta_{i1}b_1(x)]^2$ with no $\sum_i$ or $\int \cdot\, dx$ is a per-observation, per-point residual, not an objective function that can be "minimised".

**Quarto / cross-references**
- Cross-references use `@sec-label`, `@fig-label`, `@eq-label` syntax — not raw HTML links or raw text that is unlinked.
- Sections are only numbered down to level 2 (##). So do not add labels to level 3 headers (###) or lower, and do not cross-reference level 3 sections or lower.
- Equation labels should either be referenced elsewhere or be removed. Watch for typo'd labels (e.g. `eq-lookkde` for what should be `eq-loo-kde`).
- Figures should be cross-referenced from the prose, not just placed near the relevant text. Check every `fig-` label is referenced by at least one `@fig-...`; if a figure is never referenced, add a natural reference (often the lead-in sentence implicitly points to it — make the link explicit).
- Check `#| fig-cap:` values for balanced quotes — a stray trailing `"` with no opening quote (or vice versa) is a common YAML error. Either wrap the whole caption in `"..."` or leave it fully unquoted.
- Every chunk with a `fig-` label must have a `#| fig-cap:` — don't just eyeball this, run `grep -A5 '^#| label: fig-' file.qmd` (or compare `grep -c '^#| label: fig-'` against `grep -c '^#| fig-cap:'`) for every chapter reviewed and confirm each `fig-` labelled chunk has a matching caption line; a missing caption is easy to miss by reading prose alone since the figure still renders fine without one.
- Captions should not introduce mathematical notation (e.g. $c_{\text{SD}}$) that is never defined in the surrounding text; use words instead, or define the symbol in the text.

**Accuracy**
- Variable counts in prose match the code
- Index variables are consistent (e.g. vector of length $m$ indexed to $m$, not $n$ which is used for sample size)
- Values quoted in text match values in code
- Inline-code variable names in prose must match the actual column names used in the code (e.g. `pm2_5`, not `pm_25`).
- Figure captions describe what is actually shown — watch for captions copy-pasted between sibling figures (e.g. a ROBPCA outlier-map grid reusing the classic-PCA caption verbatim).
- A caption claiming "first two Xs" (or similar) can be stale even without copy-paste: check what the chunk body actually selects/pivots — e.g. `select(-id_col) |> pivot_longer(...)` or `select(-id_col) |> GGally::ggpairs()` sweeps in *every* remaining numeric column, so if the upstream object has three components the plot shows three, not two. The very next sentence of prose is often a tell: if it already says "the first three" or discusses a third series/component, the caption above it is the one that's wrong.
- A score distance $\text{SD}_i$ is the *square root* of a Mahalanobis form, so it is the *squared* distance that follows a chi-squared distribution, and the cutoff is the *square root* of the chi-squared quantile. Check this is stated precisely.
- Missing words in sentences (especially in figure captions auto-generated from incomplete text)
- Subject-verb agreement with citations: `@key` with multi-author works renders as "Author1 & Author2 (year)" and takes a plural verb ("show", "argue"); single-author renders as "Author (year)" and takes a singular verb.
- Subject-verb agreement with collective subjects: "the cluster of five points ... correspond" should be "corresponds" — the head noun ("cluster") is singular even when followed by a plural of-phrase.
- Geometric descriptions must match the example that follows: e.g. directions that "project onto the carbon monoxide axis" ($\bm{a}=(1,0)^\intercal$) are *aligned with* the coordinate axes, not "perpendicular to the axes".
- Check that referenced citation keys exist in `weird.bib`.
- When prose converts a symmetric two-sided threshold (e.g. a z-score/MAD threshold $k$, as in the Hampel identifier) into an equivalent surprisal probability $\alpha$, check the formula matches the book's own definition: for a symmetric distribution the two-sided tail probability is $\alpha = 2\Phi(-k)$ (or $2[1-\Phi(k)]$), not the one-sided $\Phi(-k)$/`pnorm(-k)`. Verify any inline-R computation like `` `r pnorm(-3)` `` includes the factor of 2 when the surrounding text describes a two-sided/absolute-value rule.
- Hardcoded facts (dates, row/column counts, category counts) about a data set that a chunk loads via a `fetch_*()` helper rather than an inline `` `r ...` `` expression can silently drift from the actual source data. Where feasible, actually load the data (`Rscript -e 'library(weird); ...'`, fetching if necessary) and check the literal figure against it, rather than trusting the prose. If a count is likely to drift (e.g. `n_distinct()` of a category), prefer converting the hardcoded number to an inline `` `r ...` `` expression — matching the pattern already used for row counts in the same sentence — rather than just patching in a new literal.
- The same drift risk applies to an approximate magnitude claim written as plain prose (e.g. "nearly a 100-fold reduction", "about 10 years") — these look like harmless rounding but can still be checked against the actual data (compute the ratio/count from the raw or smoothed series) and corrected if the real value is well outside the stated range.
- If a count (e.g. "all five methods") is hardcoded in one sentence while the *same* count is computed dynamically via inline `` `r ...` `` elsewhere in the chapter (from an object already in scope at that point in the document), convert the hardcoded instance to reference that computation too, rather than leaving two sources of truth that can silently diverge.
- A code-backed sanity check embedded as `stopifnot()` (often in an `include: false` chunk placed right after a prose claim, to guard against the claim silently going stale) must fail exactly when the claim becomes false, not when it holds — i.e. the boolean expression inside `stopifnot()` should be the condition that must remain TRUE for the prose to still be correct, not its negation. Trace through by hand which direction throws, or actually run the R to check both the current truth value and that the logic points the right way; also check the reference set the assertion compares against actually matches what the prose claims (e.g. "previously identified" may mean the union of several earlier methods' flagged sets, not just the most recently discussed one).

**Clarity for 3rd year undergraduates**
- Notation introduced before it is used
- No unnecessary complexity beyond what the content requires
- Intuition before mathematical formulation
- Use precise terminology: in multivariate KDE the smoothing parameter is a "bandwidth matrix", not just "the bandwidth".

**Spelling**
- Use Australian spelling throughout. Check for spelling consistency.

**R chunks**
- All R chunks should have labels. Don't just eyeball this — count `grep -c '^```{r}' file.qmd` vs `grep -c '^#| label:' file.qmd`; a mismatch means at least one unlabelled chunk (often a small inline-display chunk like `df |> arrange(x)` added between two labelled chunks).
- If an R chunk uses an object created in a previous chunk, add a dependency using `#| dependson <chunk-label>`. This includes a `#| fig-cap: !expr paste(...)` (or similar) that references a variable computed in an earlier `echo: false` chunk — the caption expression is still a use of that object and needs the same `dependson`, even though the dependency isn't visible in the chunk body.
- Do not just check the immediately preceding chunk — trace every object a chunk uses back to the chunk that actually created it, which can be several sections earlier (e.g. a "wide" data frame built once early in the chapter and reused much later when constructing a functional-data object, or a filtered subset object reused two sections on). List every object referenced in the chunk body and confirm each one's origin chunk (or an earlier chunk already in its `dependson` chain) is covered; also check a "sanity-check" chunk placed right after a prose claim (see the `stopifnot()` item above) — these are easy to leave without any `dependson` at all since they have no visible pipeline of their own.
- Do not change any code contained in an R chunk
- A chunk label starting `fig-` should belong to a chunk that actually produces a plot. Watch for chunks that only fit a model or prepare data but were left with a stale `fig-` label and `fig-cap` (likely a leftover from restructuring) — the caption ends up describing an output that doesn't exist and the label is never (or wrongly) cross-referenced. Rename the label (dropping `fig-`) and remove the orphaned `fig-cap`; update any downstream `#| dependson:` that pointed at the old label. After such a rename, `quarto render <file> --to html` is worth running to confirm cross-references still resolve and figure numbering is unaffected.
- Conversely, watch for chunks that *do* produce a plot (e.g. call a plotting helper like `pbs_plot()`, or end in `autoplot()`/`ggplot()`) but were left with a plain (non-`fig-`) label and no `#| fig-cap:` — often several near-identical example chunks late in a chapter, added without following the figure convention used elsewhere. If every other displayed plot in the chapter is a numbered, captioned, cross-referenced figure, convert these too (rename label to `fig-...`, add a `#| fig-cap:`, add an `@fig-...` reference in the lead-in sentence) for consistency, then re-render to confirm figure numbering and cross-references resolve.

## What NOT to change

- The overall structure, argument, or style of the chapter. You may suggest changes to the overall structure or style, but do not make such changes.
- Correct passages that are merely informal or conversational
- Unicode mathematical characters (e.g. `𝟙` for indicator) that the author has deliberately chosen — these render through MathJax.

## Output format

After making all fixes, report a concise table of what was changed:

| Location | Issue | Fix applied |
|----------|-------|-------------|
| Line N | Description | What was done |

Also provide any other suggestions or comments that may improve the chapter.
