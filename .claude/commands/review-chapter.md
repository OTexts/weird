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
- The data dimension is $m$ consistently throughout the book.
- For regression problems, use $p$ for the number of predictors (including the intercept where included).
- Bold notation applied consistently to vectors and matrices
- Matrix transposes use `^\intercal`, not `'` or `^T` or `^\prime`.
- Subscript/superscript placement correct (e.g. `$\bm{S}^*$` not `$\bm{S^*}$`)
- Same symbol not used for two different things in the same chapter.
- Within a chapter, a quantity should use one consistent symbol.
- Distribution names use upright (non-italic) font: `N(0,1)` not `$N(0,1)$`. When parameters contain maths symbols, put only the parameters in maths: `N$(\mu, \sigma^2)$` or `$\text{N}(\mu, \sigma^2)$`.
- Compound expressions used as adjectives/quantifiers should be parenthesised in maths: `$(1-\beta)$ sample quantile`, not `$1-\beta$ sample quantile`.

**Quarto / cross-references**
- Cross-references use `@sec-label`, `@fig-label`, `@eq-label` syntax — not raw HTML links or raw text that is unlinked.
- Sections are only numbered down to level 2 (##). So do not add labels to level 3 headers (###) or lower, and do not cross-reference level 3 sections or lower.
- Equation labels should either be referenced elsewhere or be removed. Watch for typo'd labels (e.g. `eq-lookkde` for what should be `eq-loo-kde`).

**Accuracy**
- Variable counts in prose match the code
- Index variables are consistent (e.g. vector of length $m$ indexed to $m$, not $n$ which is used for sample size)
- Values quoted in text match values in code
- Figure captions describe what is actually shown
- Missing words in sentences (especially in figure captions auto-generated from incomplete text)
- Subject-verb agreement with citations: `@key` with multi-author works renders as "Author1 & Author2 (year)" and takes a plural verb ("show", "argue"); single-author renders as "Author (year)" and takes a singular verb.
- Check that referenced citation keys exist in `weird.bib`.

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
