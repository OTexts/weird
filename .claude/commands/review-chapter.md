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
- Bold notation applied consistently to vectors and matrices
- Subscript/superscript placement correct (e.g. `$\bm{S}^*$` not `$\bm{S^*}$`)
- Same symbol not used for two different things in the same chapter.
- Distribution names use upright (non-italic) font: `N(0,1)` not `$N(0,1)$`. When parameters contain maths symbols, put only the parameters in maths: `N$(\mu, \sigma^2)$` or `$\text{N}(\mu, \sigma^2)$`.
- Within a chapter, a quantity should use one consistent symbol.
- Compound expressions used as adjectives/quantifiers should be parenthesised in maths: `$(1-\beta)$ sample quantile`, not `$1-\beta$ sample quantile`.

**Quarto / cross-references**
- Cross-references use `@sec-label`, `@fig-label`, `@eq-label` syntax — not raw HTML links or raw text that is unlinked.
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
- When a model is named (GMM, Gaussian copula, etc.), include a formal density formula so the rest of the section has a concrete mathematical anchor.
- Use precise terminology: in multivariate KDE the smoothing parameter is a "bandwidth matrix", not just "the bandwidth".
- Rank-based probability formulas can be hard to parse with mixed operator precedence; prefer `$(n - \text{rank}(s_i) + 1)/n$` to `$1 - \text{rank}(s_i)/n + 1/n$`.

**Spelling**
- Use Australian spelling throughout. Check for spelling consistency.

## What NOT to change

- Code chunks (R code) — only fix comments or labels if they contain errors
- The overall structure, argument, or style of the chapter. You may suggest changes to the overall structure or style, but do not make such changes.
- Correct passages that are merely informal or conversational
- Unicode mathematical characters (e.g. `𝟙` for indicator) that the author has deliberately chosen — these render through MathJax.

## Output format

After making all fixes, report a concise table of what was changed:

| Location | Issue | Fix applied |
|----------|-------|-------------|
| Line N | Description | What was done |

Also provide any other suggestions or comments that may improve the chapter.
