# Review Chapter

Review a book chapter (.qmd file) of "That's Weird! Anomaly Detection using R" for notational consistency, accuracy, and clarity. The target audience is 3rd year undergraduates studying statistics at Australian universities.

## Instructions

The user will either name a chapter (e.g. "chapter 3" or "03-multivariate.qmd") or you should infer it from context (e.g. the currently open file). If the chapter is ambiguous, ask.

Read the entire chapter in sections using offset/limit, then apply all fixes directly to the file. Do not just report issues — fix them. The user can choose to discard them via sublime merge if needed.

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

**Quarto / cross-references**
- Cross-references use `@sec-label`, `@fig-label`, `@eq-label` syntax — not raw HTML links or raw text that is unlinked.
- Sections are only numbered down to level 2 (##). So do not add labels to level 3 headers (###) or lower, and do not cross-reference level 3 sections or lower.
- Equation labels should either be referenced elsewhere or be removed. Watch for typo'd labels (e.g. `eq-lookkde` for what should be `eq-loo-kde`).
- Figures should be cross-referenced from the prose, not just placed near the relevant text. Check every `fig-` label is referenced by at least one `@fig-...`; if a figure is never referenced, add a natural reference (often the lead-in sentence implicitly points to it — make the link explicit).
- Check `#| fig-cap:` values for balanced quotes — a stray trailing `"` with no opening quote (or vice versa) is a common YAML error. Either wrap the whole caption in `"..."` or leave it fully unquoted.
- Captions should not introduce mathematical notation (e.g. $c_{\text{SD}}$) that is never defined in the surrounding text; use words instead, or define the symbol in the text.

**Accuracy**
- Variable counts in prose match the code
- Index variables are consistent (e.g. vector of length $m$ indexed to $m$, not $n$ which is used for sample size)
- Values quoted in text match values in code
- Inline-code variable names in prose must match the actual column names used in the code (e.g. `pm2_5`, not `pm_25`).
- Figure captions describe what is actually shown — watch for captions copy-pasted between sibling figures (e.g. a ROBPCA outlier-map grid reusing the classic-PCA caption verbatim).
- A score distance $\text{SD}_i$ is the *square root* of a Mahalanobis form, so it is the *squared* distance that follows a chi-squared distribution, and the cutoff is the *square root* of the chi-squared quantile. Check this is stated precisely.
- Missing words in sentences (especially in figure captions auto-generated from incomplete text)
- Subject-verb agreement with citations: `@key` with multi-author works renders as "Author1 & Author2 (year)" and takes a plural verb ("show", "argue"); single-author renders as "Author (year)" and takes a singular verb.
- Subject-verb agreement with collective subjects: "the cluster of five points ... correspond" should be "corresponds" — the head noun ("cluster") is singular even when followed by a plural of-phrase.
- Geometric descriptions must match the example that follows: e.g. directions that "project onto the carbon monoxide axis" ($\bm{a}=(1,0)^\intercal$) are *aligned with* the coordinate axes, not "perpendicular to the axes".
- Check that referenced citation keys exist in `weird.bib`.
- When prose converts a symmetric two-sided threshold (e.g. a z-score/MAD threshold $k$, as in the Hampel identifier) into an equivalent surprisal probability $\alpha$, check the formula matches the book's own definition: for a symmetric distribution the two-sided tail probability is $\alpha = 2\Phi(-k)$ (or $2[1-\Phi(k)]$), not the one-sided $\Phi(-k)$/`pnorm(-k)`. Verify any inline-R computation like `` `r pnorm(-3)` `` includes the factor of 2 when the surrounding text describes a two-sided/absolute-value rule.

**Clarity for 3rd year undergraduates**
- Notation introduced before it is used
- No unnecessary complexity beyond what the content requires
- Intuition before mathematical formulation
- Use precise terminology: in multivariate KDE the smoothing parameter is a "bandwidth matrix", not just "the bandwidth".

**Spelling**
- Use Australian spelling throughout. Check for spelling consistency.

**R chunks**
- All R chunks should have labels
- If an R chunk uses an object created in a previous chunk, add a dependency using `#| dependson <chunk-label>`.
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
