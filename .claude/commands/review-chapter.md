# Review Chapter

Review a book chapter (.qmd file) of "That's Weird! Anomaly Detection using R" for notational consistency, accuracy, and clarity. The target audience is 3rd year undergraduates studying statistics at Australian universities.

## Instructions

The user will either name a chapter (e.g. "chapter 3" or "03-multivariate.qmd") or you should infer it from context (e.g. the currently open file). If the chapter is ambiguous, ask.

Read the entire chapter in sections using offset/limit, then apply all fixes directly to the file. Do not just report issues — fix them. The user can choose to discard them via sublime merge if needed.

Also update this skill to take account of any new issues you find when reviewing the chapter.

## What to check

**Notation consistency**
- Math symbols used consistently throughout (e.g. `\Pr` vs `\text{Pr}`, `\le` vs `\leq`, `\bm{}` for vectors/matrices)
- Parameter lists in pdfs match the parameterisation stated in the text
- Bold notation applied consistently to vectors and matrices
- Subscript/superscript placement correct (e.g. `$\bm{S}^*$` not `$\bm{S^*}$`)
- Same symbol not used for two different things in the same chapter.

**Quarto / cross-references**
- Cross-references use `@sec-label`, `@fig-label`, `@eq-label` syntax — not raw HTML links or raw text that is unlinked.

**Accuracy**
- Variable counts in prose match the code
- Index variables are consistent (e.g. vector of length $m$ indexed to $m$, not $n$ which is used for sample size)
- Values quoted in text match values in code
- Figure captions describe what is actually shown
- Missing words in sentences (especially in figure captions auto-generated from incomplete text)

**Clarity for 3rd year undergraduates**
- Notation introduced before it is used
- No unnecessary complexity beyond what the content requires

## What NOT to change

- Citation page locators: use concise form `[p44]` not `[p. 44]`
- Code chunks (R code) — only fix comments or labels if they contain errors
- The overall structure, argument, or style of the chapter. You may suggest changes to the overall structure or style, but do not make such changes.
- Correct passages that are merely informal or conversational

## Output format

After making all fixes, report a concise table of what was changed:

| Location | Issue | Fix applied |
|----------|-------|-------------|
| Line N | Description | What was done |

Also provide any other suggestions or comments that may improve the chapter.
