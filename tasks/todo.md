# Reader-reproducible plot maths: show TeX(), run tex() (2026-10-16)

- [x] tex-labels.R: `TeX <- tex` alias; treat `\textbf{}` as bold italic (vectors) so labels work with plain latex2exp
- [x] before-each-chapter.R: text layers default to BookMath via `element_geom(family = )`
- [x] Remove `family = "BookMath"` from chunks; keep Fira Sans for bold text labels
- [x] `\bm{}` -> `\textbf{}` in the two plot labels (distance, appendix)
- [x] `tex(` -> `TeX(` in all chapters
- [x] Preface: last sentence about loading **`latex2exp`**
- [x] Update .claude/CLAUDE.md
- [x] Render affected chapters; diff figures against previous build
- [x] `unname()` on `TeX(c(...))` passed straight to a discrete scale (timeseries, univariate), as plain TeX() returns names that ggplot2 4 matches to breaks
- [x] `update_geom_defaults()` for text and label, as theme_void() resets the theme's geom family

## Review

All figures in the eight chapters are pixel-identical to the previous build. The first render wasn't: fig-njk and fig-tscvplots use theme_void(), which drops `element_geom(family = )`, and their chunk caches then held the wrong fonts, which were cleared. Chunk code shown to readers now runs with `library(latex2exp)`; the only differences are the fonts and bold (not bold italic) vectors.

# Chapter 10: Categorical and textual data (2026-10-09)

Plan: hidden PLAN block in text.qmd. Data: BITRE road deaths, wine_reviews (with descriptions), Baum/Thompson Oz books.

Data and dependencies
- [x] weird: restore `description` column in wine_reviews (data-raw + fetch_wine_reviews())
  - now 111,592 rows (was 110,203): dedup includes description, so 1,389 distinct reviews no longer merged. Old rows all retained; Rulo claim (ch1) unchanged; ch8 Shiraz coefs change in 3rd decimal. Book's rds/wine_reviews.rds cache must be refreshed after pushing weird; then re-render ch1, ch8 and diff against deployed pages
- [x] weird: road_deaths package data from the BITRE Australian Road Deaths Database (CC BY); check variables and licence
  - 58,168 deaths, Jan 1989 to Dec 2025 (later months still being revised), 20 columns. -9/Unknown/99:99:99 -> NA. remoteness/sa4/lga/road_type only from ~2015; heavy_rigid_truck mostly NA before 2002
- [x] weird: fetch_oz_books() (option B: full text on GitHub, data-raw/oz_books.rds, 1.9 MB)
  - 29 books (Baum 14, Thompson 15 incl. Royal Book), 31,258 paragraphs, 1.22M words, 655 chapters. Raw Gutenberg files in data-raw/oz/; plain downloads, no gutenbergr
- [x] Add tidytext to uvr.toml; uvr sync (FactoMineR already installed)

Sections
- [ ] 1. Anomalies in categorical data (surprisals, surprisal probabilities with ties, rare combinations, anomalous cells); road deaths
- [ ] 2. Correspondence analysis and MCA; wine country x variety
- [ ] 3. Mixed numerical and categorical data (f(y|x) p(x); Gower, FAMD); wine, road deaths
- [ ] 4. From text to numbers (tidytext, DTM, tf-idf, function words)
- [ ] 5. Feature-based anomalies in text; wine descriptions
- [ ] 6. Language-model surprisals and perplexity; wine descriptions; AI-text detection discussion
- [ ] 7. Authorship verification as one-class anomaly detection; Royal Book of Oz
- [ ] Chapter summary (methods, not example results)

Cross-chapter
- [ ] highdim.qmd HDoutliers: replace forward use of "correspondence analysis" with plain words + @sec- reference to ch10
- [ ] Bibliography entries (Silge & Robinson, Greenacre, Binongo 2003, Mosteller & Wallace, Burrows 2002, Koppel & Schler 2004, DetectGPT, Binoculars)

Finish
- [ ] Render text.qmd; check fig- labels vs fig-cap, guard chunks, values cited in prose
- [ ] Remove PLAN block from text.qmd

## Review

# Emphasis and package-name consistency (2026-10-06)

Convention: **bold** = term at its definition only; *italics* = stress only; "quotes" = word-as-word / scare quotes. Packages = bold monospace (`**`pkg`**`).

- [x] Packages: `pkg` -> **`pkg`** in prose and captions
- [x] Italic definitions -> bold
- [x] Quoted definitions -> bold (keep quotes for word-as-word)
- [x] Unmarked definitions -> bold
- [x] Mixed/doubled styles (KDE surprisal, lookout, orthogonal distance, ch1 anomaly definition, oddnet)
- [x] Step labels: consistent trailing full stop
- [x] Render affected chapters and check HTML

## Review
About 50 term edits across 14 files (italic, quoted and unmarked definitions now bold; ch1 anomaly definition bolds only the term; orthogonal distance bolded once, at its definition; KDE surprisal and lookout lose their quotes). Packages: 46 backticked mentions are now **`pkg`** in prose (headings left as `pkg`, since headings are already bold). In ch12, references to the oddnet *method* are plain text, like lookout and stray; the package is **`oddnet`**. Ch6 step labels now put the full stop inside the bold. make build exit 0; <strong><code> verified in the HTML. Follow-up: Quarto fixes inline code at weight 400, so set $font-weight-monospace-inline: inherit in otexts.scss; bold confirmed by screenshot. Package names also drop the inline-code box (:is(p,li,td) strong>code:not(.sourceCode), to outrank Quarto's p code:not(.sourceCode)); screenshot confirmed. Not committed.

# Chapter 13: Image and video data (2026-10-06)

Plan: ~/.claude/plans/fuzzy-tumbling-grove.md. Fashion-MNIST (1000 test-set sneakers + ~10 planted items) for all image methods; CDnet 2014 PETS2006 for robust-PCA video (Candès's I2R airport data no longer downloadable).

- [x] data/fashion_mnist.R -> rds/fashion.rds
- [x] Add rpca, jpeg, png to uvr.toml; uvr sync
  - side effect: dbscan 1.2.6 -> 1.2.7, vital 2.0.3 -> 2.1.0; ch3/6/9 re-rendered with --cache-refresh to check guards: ch3, ch6 pass
  - ch9 robpca-maps-check failed on a fresh-cache render: not dbscan, but PcaHubert unseeded (results depend on RNG use by earlier chunks, so on caching). Added set.seed(1967) in fig-pca-outliermap2 and made the PC4 loading check sign-invariant; ch9 passes with --cache-refresh
- [x] Ch13 intro + Fashion-MNIST data section (plot_images helper)
- [x] PCA of images (eigen-images, variance, choice of k)
- [x] Anomalies in PC scores: all methods + comparison (planted recall, top-anomaly grids, seed checks)
- [x] Image features + same methods + comparison with PCA route
  - GLOSH: with k = 20, HDBSCAN finds no clusters among the features and dbscan returns score 1 for all; ch13 uses k = 10 for kNN/LOF/GLOSH (same in dbscan 1.2.6)
- [x] PETS2006: Rob downloaded (Kaggle archive.zip); data/pets2006.R -> rds/pets2006.rds (301 frames, 120x96, 1.5 MB)
- [x] Video section: ROBPCA orthogonal distances per frame (cor 0.92 with truth), median background + residual maps
  - rpca dropped (Rob): rpca::rpca() ran > 2.5 h (fixed mu); inexact ALM converged but L had rank 159 and barely beat mean-frame subtraction. Removed from uvr; ch9 pointer removed
- [x] Summary; bib entries; .claude/CLAUDE.md stub line
- [x] Render ch13 (guards pass, figures inspected); make build (exit 0, no unresolved refs)

## Review
Ch13 complete: Fashion-MNIST (PCA scores + OD, 10 methods; 7 image features, 8 methods; planted-item recall and top-10 grids), PETS2006 (ROBPCA OD per frame, median-background residual maps). Every quoted number has a guard. Side fix: ch9 ROBPCA maps seeded (guard failed on fresh cache). Not committed.

# Fresh review of chapters 1–12 (2026-10-02)

- [x] Per-chapter review (one subagent per chapter, review-chapter checklist + deslop); clear errors fixed
- [x] Cross-book checks: labels unique, all @refs resolve, notation, Test cricket, distribution capitalisation
- [x] review-chapter.md extended with new checks; .claude/CLAUDE.md stub line updated (ch 1–12 now substantial)
- [x] Full `make build` OK (all guards pass, no unresolved refs)

## Suggestions from the fresh review
- [x] ch12: oddnet::anomalous_networks() builds Senate graphs as *directed* (edges doubled; path features differ from the undirected illustration at L332)
  - 2026-10-02: oddnet 0868e0c passes `...` to graph_from_adjacency_matrix(); ch12 now calls anomalous_networks(senate_networks, mode = "undirected") and the interim text note is gone. Results unchanged (max prob diff 4e-11): the directed features are identical or exactly doubled, and the doubling cancels after ARIMA + trimmed scaling. UCI correctly left directed
- [x] ch10: surveillance scores late-starting series (A05) after 5 obs although I = 36; first A05 value prob = 0 counts as flagged
  - 2026-10-02: two late series (L03 from Dec 1992 after 5 leading zeros; A05 from Nov 2000). Loop and first-iteration fit now use only series with >= 36 obs counting from first non-zero value; check_late_series guard. Rescored only L03/A05 and spliced into rds/pbs_scores.rds (full loop > 1 h; refit of A12/N07/S01 matched old scores to 1e-11). 15 flags removed (13 L03, 2 A05), none added; joint alarms now Dec 1997, Mar 1999, Dec 2001, Feb 2008 (Jan 1998 gone); M_t 82/83/84 (Jul 1995/Dec 1995/Nov 2003); prose + check_pbs_joint updated
- [x] ch10: $n$ used as count threshold in Pr(N_t >= n) (L1087, 1103) clashes with sample size
  - 2026-10-02: now observed count n_t, Pr(N_t >= n_t)
- [x] ch7: no guard that Mclust() picks 3 components; Old Faithful example uses robust, not lookout, bandwidth right after the lookout subsection
  - 2026-10-06 (Rob): guard in gmm2; text says default bandwidth used. Lookout h collapses to 1 s here (durations in whole seconds, 91% zero gaps) -> see weird lookout-ties fix
- [x] ch4: Summary leads with results table and omits gap methods; z-scores "approximately t_{n-1}" (L223) is loose
  - 2026-10-02: t_{n-1} was wrong, not loose (z-scores have lighter tails than Normal; t was the worst approximation vs simulation). Now N(0,1), eq-spuriousz uses Phi, plus |z_i| <= (n-1)/sqrt(n) (no z > 3 for n <= 10)
  - Summary structure kept (Rob's earlier decision); added clause on the gap test's 68 Old Faithful flags. These are every whole second 207-274 s (rounding artefact, not bimodality); explained in the gap section with a guard in checkgap
- [x] ch5: Summary very short; dead hidden `lv` chunk; `median <-` masks stats::median (L503)
  - 2026-10-02: `lv` chunk (stat_lv() outside a plot, unused) replaced by guard check-lv (outermost box Z; 10 points shown, max = Bradman); `median` -> `bagplot_fit`; method-focused summary paragraphs added before Rob's existing two; ch5 renders
- [x] ch8: manual rank vs surprisals_prob(rank) tie handling differ (L411–427); Boult record claim uncited (L616)
  - 2026-10-06: manual chunk now uses ties.method = "min" (= package rank(-s, ties = "max")/n); ch7 rank formula states the tie rule. Boult claim correct, no citation needed (Rob)
- [ ] weird: surprisals.lm() gives identical observations surprisals differing at ~1e-15, so rank approximation splits genuine ties (2 Shiraz rows differ from the manual calc); round s before ranking in surprisal_prob_from_s() — Rob: leave for now
- [x] ch2/ch3: no Summary section (all other chapters have one)
  - 2026-10-02: not needed (Rob): chs 2 and 3 are background reference material
- [x] ch3/ch6: letter reuse (h, H, K, c, r, k; bold m next to dimension m)
  - 2026-10-06: BACON s = 4m (no bare c next to c_nmr; ch8 defines its own c); Euclidean sum index k -> q; ch3 "h = sqrt(H)" -> "H = h^2"; median vector bold m -> tilde y (ch3, ch6). h/r/K reuse left (Rob agreed)
- [x] ch9: Stahel–Donoho called a "guided tour index" (L330, 591); stray [0,1] rescaling not mentioned (L1403)
  - 2026-10-06: reworded as projection pursuit; stray unitize noted (scores identical on raw vs standardised data, checked); also fixed "uses kd trees" (default knnsearchtype is brute; kd gives identical scores)
- [x] ch11: guards for literal year lists (L827 outliergram 1940/41/43; n_agree == 5L hard-coded); band depth/MBD/MEI/parabola not given as formulas
  - 2026-10-06: outliergram-check guard (years + all curves under the parabola); n_agree == n_distinct(Method); displayed BD, MBD, MEI and parabola (a2 = n^2 a0, matching code)
- [x] ch12: verify Huang2020 claim (L554) and UCI 2004 term dates (L650)
  - Huang et al. used a different Senate co-sponsorship network (97th--108th Congresses); UCI dates corrected to Spring finals and the first day of Fall instruction from official calendars
- [ ] weird package docs say 44 countries in wine_reviews; data have 42

# Review of chapters 1–12 (2026-09-30)

- [x] Per-chapter review (one subagent per chapter, using .claude/commands/review-chapter.md checklist); fix clear errors only
  - [x] 01-intro  - [x] 02-univariate  - [x] 03-multivariate  - [x] 04-tests
  - [x] 05-boxplots  - [x] 06-distance  - [x] 07-density  - [x] 08-regression
  - [x] 09-highdim  - [x] 10-timeseries  - [x] 11-functional  - [x] 12-network
- [x] Cross-chapter notation consistency sweep (grep across all chapters)
- [x] Apply cross-chapter fixes
- [x] Update review-chapter skill with new checks found
- [x] Render book to confirm nothing broke
- [x] Summarise fixes, major suggestions, and completeness verdict per chapter

## Review
All 12 chapters reviewed and clear errors fixed (~300 small edits; see git diff). Book-wide sweep:
$z$-score typesetting normalised; dependson/label checker passes on all chapters; all cite keys resolve.
Full `make build` succeeded (all stopifnot checks pass). review-chapter.md extended with new checks.
Major suggestions and completeness verdicts reported in chat, not applied.

## Follow-up: ch4 larger issues #1, #2 (done)
- [x] Peirce/Chauvenet cricket examples now use `filter(Innings > 20)`; stopifnot updated; text says Bradman found
- [x] Pearson–Sekar: explained one-sided / divisor-n derivation, ~2α size on |z|; Grubbs as the correction; revised size discussion
- [x] Re-rendered 04-tests.qmd; summary table cricket row now 1 for all methods

## Follow-up: cricket filter `Innings >= 20` everywhere (done)
- [x] ch1, 2, 4, 5, 8: all `Innings > 20` / `> 25` → `>= 20`; prose/captions "at least 20"
- [x] ch5 letter-value display made generic for half-integer depths (n = 1254 is even)
- [x] ch4 gap section: second-highest batter is now Kamindu Mendis (24 innings), guard chunk added; p = 0.028 wording softened
- [x] Rendered ch1, 2, 4, 5, 8; all stopifnot checks pass

## Follow-up: weird package k/minPts fix (#3) (done, uncommitted in ~/git/R/weird)
- [x] lof_scores()/glosh_scores(): minPts = k + 1 so k excludes the point itself (matches kNNdist)
- [x] Roxygen docs fixed (default was documented as 5, actually 10); NEWS entry; 2 new tests
- [x] Full package tests pass (568); ch6 LOF/GLOSH claims re-checked with fixed code — unchanged

## Follow-up: #4 ch2 GPD_from_GEV scale (done)
- [x] Code now uses sigma_u = sigma_G + xi (u - mu_G), matching the displayed formula
- [x] "better" claim softened to "should be more accurate", with draw counts; checked by simulation (20 reps): GEV-derived GPD mean abs density error ~0.025 vs ~0.056 for direct GPD fit
- [x] ch2 re-rendered

## Follow-up: #5 ch12 node PCA scaling + terminology (done)
- [x] Node features standardised (mvscale mean/sd, as ch9) before PCAproj
- [x] Found & fixed weird bug: kde_bandwidth(method="lookout") segfaulted (mlpack::emst C stack overflow) on near-duplicate points; now rounds scaled data to 10 dp; test added; 570 tests pass
- [x] New results: flagged = top-2 betweenness senators + 3 isolated senators; prose, checks, figure highlight/caption rewritten; guard chunk added
- [x] "conditional probability" -> "surprisal probability" throughout ch12 (incl. plot axis), with a sentence explaining oddnet's term
- [x] Local weird dev version installed into .uvr/library to render; ch12 renders

## Follow-ups #6, #8 (done)
- [x] #6 ch11: trend explanation (l.728, summary) rewritten — trend lives in PC1 as a continuous path; war years stand out on PC2
- [x] #7 already done (cricket >= 20)
- [x] #8 ch10 Hampel half-width h -> w; ch6 iTree split q,p -> v,tau and iForest score s -> a(y, psi); ch7 GMM weights w_k -> pi_k
- [x] ch4 render error after user removed Pearson curve: label frames fixed, pearson rows dropped from rds/pzscoredf.rds

## Minor polish (done)
- [x] Unreferenced eq labels: ch2 eq-iqr/eq-mad/eq-POT now referenced, eq-cdf/spacing/hdr/POT3 removed; ch3 eq-mhdr removed, eq-lookoutH referenced from ch7
- [x] ch10 chunk label ch11_functions -> ch10_functions
- [x] En-dashes in ch4 plot label and ch12 comment; ch7 GMM/copula axis + legend labels; ch11 axis labels b_j, beta_ij
- [x] ch12 level-3 labels removed, refs reworded
- [x] ch11 citation -> "Hyndman and Shang (2008, 2010)"; oddnet still arXiv-only per robjhyndman.com, left as is
- [x] Century style already consistent; ch8 not-out hyphenation standardised
- [x] Full make build OK, no unresolved refs, dependson checker clean

## REMAINING from 2026-09-30 review
Status at end of 2026-10-01: Ch 10, Ch 12 and Ch 3 content items done and committed. Ch 9 content gaps done 2026-10-02. NEXT: Ch 2 ending,
Summaries for Chs 6–9, Ch 1–2 roadmap, then the factual/technical list. See also tasks/lessons.md.
Line numbers are approximate (as of 2026-09-30); re-grep before editing.
Before any full build: ensure weird kde_bandwidth near-duplicate fix is pushed to GitHub and `make update` run
(the dev version was installed locally into .uvr/library to render ch12).

### Content gaps (do Ch 10 and 12 first)
- [x] Ch 10: add closing Summary; "Weird series" needs explanation of the feature-based idea + citation; joint multi-series surveillance promised (l.151, 665) but not shown
  - Feature-based explanation + Hyndman2015-lsuts (new bib entry) and fpp3 Ch 4; feature count inline
  - New "Surveillance across several series": count of flagged groups per month vs Binomial(M, pi), pi estimated in real time
    (Fisher's combination rejected: ETS densities too narrow, 2% of obs have p < 0.001, 59/168 months flagged)
    Flags Dec 1997, Jan 1998, Mar 1999, Dec 2001, Feb 2008 (33/84 groups); guard chunk added
  - Summary + further reading (Blazquez-Garcia2020-kl, Talagala2020-fp); ch10 renders cleanly
- [x] Ch 12: add Summary + further reading; introduce graph notation (nodes/edges, adjacency matrix, directed vs undirected); §12.2 is a 2-sentence intro over level-3 subsections — consider promoting them
  - Notation paragraph in intro (G, n, directed/undirected, adjacency matrix incl. multi-edge counts); degree d_i = sum_j a_ij
  - Summary + Further reading (Kolaczyk2009, oddnet2 added to bib; Akoglu2015, Ranshous2015-kf)
  - §12.2 left as is: intro already gives the 3-step roadmap; promoting would make the subsections siblings of the examples
- [x] Ch 12 (new): UCI data has one self-loop per node (tnet lnet node-join rows, i == j); daily adjacency matrices include them
  as self-loops, inflating degree-type features. Dropping them (filter(i != j)) would change oddnet results — decide
  - Done: self-loops removed; 193 days (3 join-only days gone); 12 flagged (old 8 + 19 Apr, 27 Jun, 9 & 26 Oct); fig days 3/22/42; prose + guard updated
- [x] Ch 3: "Multivariate quantiles" is a stub; "Robust covariance" has no example; ends abruptly on Normal conditionals (move conditional-Normal formula to MVN subsection)
  - Quantiles: centre-outward idea, HDR/f_alpha as quantile of f(Y), MVN ellipsoids via chi^2 (Serfling2002 added); depth pointer
  - MVN: partitioned marginal + conditional (eq-mvn-conditional), quadratic form ~ chi^2_m (eq-mvn-chisq)
  - 2026-10-02: conditional MVN formula (eq-mvn-conditional) moved from the MVN subsection to the end of sec-conditional, so it no longer precedes the definition of conditional distributions; partition + marginal result stay in MVN subsection
  - Robust cov: simulated n01-based bivariate Normal + 50-point anomaly cluster, true/sample/MCD ellipses (fig-robust-cov) + guard (Old Faithful dropped: not Normal); conditional section now ends with links to ch8/ch10
- [x] Ch 9: HDoutliers has no example; stray example flags nothing (stray_anomaly all FALSE) and text doesn't say so
  - (HDoutliers example later removed by Rob; stray section no longer compares with k = 1)
  - HDoutliers example via stray_scores/anomalies(k = 1) (n = 722: every point its own leader; verified against archived HDoutliers 1.0.4 in scratch lib: 0 flags at alpha 0.01, only 31 May 9pm at 0.05)
  - Both rescale to [0,1]; top scores are rain hours (31 May 9pm = 11.5 mm, max). Stray k = 10: same flags; k lifts runs (31 May 9am, 29 May 11pm, 30 May 0am)
  - Guard chunks hdoutliers-check, stray-check; O3 intro sentence corrected; ch9 renders
- [x] Ch 2: ends abruptly after Weissman's theorem; link forward to @sec-hdoutliers / @sec-stray
  - 2026-10-02: Weissman completed (scaled spacings ~ iid Exp(a_n), use without knowing F) -> HDoutliers; closing paragraph removed at Rob's request; instead one forward-motivation sentence added in each section where the idea is introduced (PIT, quantiles, HDR, robust estimation, KDE, GPD; spacings already linked to gap tests). All refs checked against where later chapters actually use them
- [x] Chs 6, 7, 8: no closing Summary (only 4, 5, 11 have one); Ch 9 summary added 2026-10-02 (Rob changed his mind)
  - 2026-10-02: Ch 6 (sec-distance-summary) and Ch 7 (sec-density-summary) added; every claim checked against chapter text/figures. Ch 8 (sec-regression-summary) added later the same day
- [x] Chs 1, 2: point to empty stub chapters 13–16; Ch 1 roadmap omits Ch 8 and overstates "first seven chapters … one or two variables"
  - 2026-10-02: stub pointers kept (Rob: chapters to be written). Added "Regression methods" roadmap subsection (Shiraz example); dimension claim now "methods in Ch 4 to Ch 8 ... illustrated with one or two variables"

### Factual / technical points
- [x] Ch 9 results audit (2026-10-02): every "what method X finds" claim checked vs computed output. Fixed: OD (31 May 10pm IS visible in projection), DOBIN (22 May separated by a2, not a1), FastPCS (wind not low; SDs -> multiples of median). Guards fastpcs-check, dobin-check added
- [x] Ch 9: dobin() min-max rescales internally (norm = 1) but rotation applied to z-scored data (now norm = 0; rainfall dropped chapter-wide)
- [x] Ch 9: adjOutlyingness values ~1e17 because rainfall is 0 in 96% of hours (zero robust scale)
  - Done 2026-10-02: rainfall dropped (with explanation); new results described (3 May 8pm, 31 May 10pm pm10; 25 May; 31 May 9-11am); stahel-donoho-check guard; FastPCS notes SD came closest (3 of the run's hours)
  - 2026-10-02 check: top 10 = the 10 wettest hours in rainfall order, so the text's explanation ("recovers residual-space anomalies ... run on 11 May") is an artefact. Needs decision: explain, or drop rainfall as for FastPCS
- [x] Ch 9: HDoutliers "controls the false-discovery rate" — it's a per-test false-positive rate (fixed with the example)
- [x] Ch 7: copula rank transform caps normal scores at ~3.3 (explains missed anomalies); robust-MCD distances anticonservative vs chi^2_m
  - 2026-10-02: cap (3.30 at n = 2097) and gap-filling by ranks now explain the copula results (60 s eruption unflagged, between-cluster points w ~ -1.1; 20 flagged vs ~10 expected); guard copula-check; summary sentence aligned
  - then (Rob's decision) the whole Gaussian copula section (sec-copula) was removed, with no warning; summary sentence removed; no other refs in book
  - anticonservative claim checked by simulation: robust Mahalanobis + chi^2 is ~2-3x nominal only for n ~ 100; ~nominal for n >= 300 (book examples n = 1396, 2097; text already says 'for large n'), so no change
- [x] Ch 7: Old Faithful "lookout" examples use default robust bandwidth, not method = "lookout"
  - 2026-10-02: no change needed: the examples are described as LOO KDE surprisals, never as lookout; only the chunk label said lookout2 (renamed ofscores-bivariate)
- [ ] weird (optional): kde_bandwidth(method = "lookout") degenerates on tied/rounded data (oldfaithful$duration: h = 1 s, the rounding unit; 186 distinct of 2097). Fix: build EMST on unique(z) -> h = 4.96. Not yet done; Rob to decide
- [x] Ch 12: algorithm description omits oddnet's dropping of NA/zero-SD features and trimmed standardisation; "largest component" is really a 99th percentile
  - Step 1 notes dropping; Step 3 trimmed standardisation; UCI drops isolates + connectivity (18 features), guarded; cluster size = 99th pct
- [x] Ch 11: MBD motivation should be ties/near-zero band depth when curves cross, not computational cost (~l.619)
  - 2026-10-02: rewritten; hidden band-depth chunk: 17/184 curves share the minimum band depth, median BD 0.03 (exact BD takes seconds)
- [x] Ch 11: MMR vaccines came decades after WWII (~l.23)
  - 2026-10-02: now antibiotics + diphtheria, tetanus, whooping cough, tuberculosis (BCG), then polio late 1950s
- [x] Ch 10: COVID explanation for low mortality in weeks 3–4 of 2020 predates restrictions (~l.466, 552)
  - 2026-10-02: it's an STL artefact: 85+ rate in 2020 W3 ~ 2019 W3; trend pulled up by the April 2020 peak (0.151 vs 0.141 fitting to 2020 W10); with pre-COVID data W3 no longer flagged (p 0.019 -> 0.032). Both passages corrected; guard check_low_mortality
- [x] Ch 10 (new, for Rob): e = .resid / IQR / 1.349 should be .resid / (IQR / 1.349) to match 'equivalent to a standard deviation'; printed e values ~1.8x too small (probabilities unaffected: GPD is scale-invariant)
  - 2026-10-02 fixed: s = IQR/1.349, e = .resid / s (and in guard); probabilities and flagged count verified unchanged, e now ~1.82x larger
  - then (Rob) spread now robustbase::s_Qn(.resid) instead of IQR/1.349 (code, guard, prose citing sec-robust-univariate); same 58 flagged observations, probabilities shift slightly
- [x] Ch 10 (new, for Rob): 2021 W13/W15 low mortality attributed to 'restricted movements'; 85+ rates genuinely below 2016-19 (0.135 vs 0.145-0.154), but mortality displacement after the 2020-21 winter wave and vaccination of the elderly are likelier explanations
  - 2026-10-02: alternatives added (restricted movements, vaccination, mortality displacement); guard check_low_2021
- [x] Ch 8: Boult's not-out proportion (0.489, 16th of 1175) IS unusual, contrary to ~l.623
  - 2026-10-02: rewrite tried then reverted at Rob's request (it ignored year of debut and made Boult look like a mistaken anomaly); original sentence kept
- [x] Ch 6: setting infinite LOF to 1 is debatable (~l.468); GLOSH "epsilon_i = d_{i,k}" is a simplification (~l.537)
  - 2026-10-02 GLOSH done: eps_i = min_j d_mreach(y_i, y_j) >= d_ik, usually equal (Dongsi: 24/1396 differ, max 16%, none in top 10)
  - LOF: dbscan already gives duplicates LOF = 1; Inf only for DISTINCT points next to a duplicate group (genuinely sparser), so Inf->1 hides them; text's justification wrong. Dongsi has no Inf. Done (Rob: keep infinities): weird lof_scores() no longer maps Inf->1 (docs, NEWS, new test; 572 tests pass; uncommitted in ~/git/R/weird; dev version installed into .uvr/library); ch6 paragraph rewritten
- [x] Ch 5: "two simplest approaches" to depth promised but only Tukey depth given (~l.444)
  - 2026-10-02: minimal edit: now promises only Tukey depth (basis of the bagplot)
- [x] Ch 3: alpha used for both HDR tail prob and MCD subset proportion; eq-mcd isn't what covMcd() returns (reweighted, consistency-corrected)
  - MCD rewritten with h, raw S_H (c_H) + reweighting (chi^2_{m,0.975}) -> S_MCD = eq-mcd (what covMcd()$cov returns; verified numerically)
- [x] Ch 4: Tukey–Wainer–Schacht example dominated by mid-sample noise (many small gaps exceed 2.25) — worth a sentence
  - 2026-10-02: paragraph added (57/1253 = 4.5% flagged, mostly ~0.1-0.2 run mid-sample gaps; Bradman gap scores 2.73, ranks 17th; found only via raw-size sort). Guard ws-noise
- [x] Ch 4 (optional): summary table "N observations" shows full cricket_batting count, not the Innings >= 20 subset tested
  - 2026-10-02: fixed (all 12 cricket uses filter Innings >= 20)

## Ch 9: drop rainfall from all analyses (2026-10-02)
- [x] Define Y without rainfall (explain once: zero in 96% of hours); dobin norm = 0 on matrix (as.matrix needed: norm = 0 path fails on tibble)
- [x] Remove per-method rainfall drops/explanations (Stahel–Donoho, FastPCS, O3) and "11 variables" wording; labels 11dto2d -> 10dto2d
- [x] Re-run chapter; re-audit every results claim (§9.1 Fig 9.4, §9.2 KDE/OD/outlier map, §9.3 SD, §9.4 PCA maps, §9.5 ROBPCA, §9.6 DOBIN, §9.7 MDS, §9.8 FastPCS, §9.10 stray, §9.11 O3)
- [x] Rewrite prose + guards to match; render ch9 (guards: proj-kde-check, od-check, pca-check, robpca-iso-check, dobin-check, dobin-iso-check, mds-check, stray-check updated)

### Review
SD, FastPCS, O3 results unchanged (already rainfall-free). Everything DOBIN/PCA/MDS/stray changed: KDE now 11 hours (22 May, 25 May, pm10 spikes 3 May 8pm / 31 May 10pm);
largest ODs = dry windy 3-4 May hours; PCA k=4 bad leverage = 31 May 7am-noon; stray now has 3 hours of the 29-30 May NO2 run.
"Similar results with other methods" now qualified (kNN/GLOSH agree, LOF doesn't). Grand-tour gif regenerated with 10 variables.

## Summaries made method-focused (2026-10-02)
- [x] Chs 6, 7, 8 rewritten (no example results)
- [x] Chs 10, 11, 12 rewritten likewise (Ch 10 also notes large anomalies can distort the fitted signal nearby); Ch 4 and Ch 9 (O3) summaries left as they are, at Rob's request
- [x] Ch 9: Rob later asked for a proper summary; sec-highdim-summary added after the O3 section (method-focused)

## Ch 13 review (2026-10-07)
- [x] Prose/notation fixes, factual corrections checked against computed output (LOF bags/trousers, GMM bag ranks, feature explanations, pale-sneaker claims, frame 900 outside period 2)
- [x] Guards updated/added (fashion-method-ranks-check, fashion-gmm-check, fashion-feature-check: old one read mvscale's rotated z1 as darkness)
- [x] Chapter renders with all guards passing
- [ ] Optional (Rob): rename `shown` in fig-pets-frames (overwrites the Fashion-MNIST `shown`); `Stahel-Donoho` column label uses a hyphen

## Code-fold revisions (2026-10-07)
- [x] Unfold: ch9 robpca, ch5 fig-of-hdrboxplot, ch4 fig-n01b
- [x] Split (shown computation + folded plot): ch4 fig-ws-gaps, ch8 fig-shiraz-regression-scores, ch11 fig-pca-hdrboxplot, ch11 fig-pca-bagplot + fig-fbagplot, ch12 ch12_libraries, ch11 fig-ms-plot, ch11 fig-outliergram, ch6 fig-dongsi, ch11 fig-fr-mortality, ch11 fig-pca-scores (update downstream dependson to new labels)
- [x] Fold: ch12 senate-data, ch11 fig-pca-bases, ch3 fig-demo_strip/fig-demo-pairs/demo-rgl, ch10 pbs_plot calls (3)
- [x] Reword: ch10 stmf lead-in ("The following code reads...")
- [x] Re-render chs 3, 4, 5, 6, 8, 9, 10, 11, 12; check folds in HTML and that guards pass

### Review
All 33 changed chunks verified in rendered HTML (inside/outside `<details class="code-fold">`); all 9 chapters render, guards pass.
New computation-chunk labels: ws-gaps, dongsi, shiraz-loo-surprisals, fr-male, pca-scores, pca-bagplot, fbagplot-envelopes, pca-hdr-regions, outliergram, ms-plot, ch12_functions; downstream dependson updated.
Prose touched: ch8 lead-in to LOO surprisals split around the new chunk; ch11 hdr_regions() sentence moved between code and figure; ch12 lead-in; ch10 stmf lead-in.

## Reader-accessible data (2026-10-07)
Goal: every data file read in the book is reachable by readers; data/ = reader data, rds/ = caches only.
- [x] weird pkg: add `senate_edges` (congress, from, to) and `senate_members` (congress, node, party) tibbles (data-raw/senate.R, xz), docs in R/datasets.R, _pkgdown.yml, NEWS; check size < 5 MB; install
- [x] Ch12: use package data instead of data/*.csv; update prose
- [x] git mv rds/fashion.rds, rds/pets2006.rds -> data/; update data/*.R generator scripts
- [x] Delete unused data/: the-tate-collection.csv, crime/, unvotes.R, senate_*.csv
- [x] _quarto.yml resources: publish data files; Makefile deps include data/
- [x] Ch1, ch10, ch13: read from https://OTexts.com/weird/data/...; add `other-links` sidebar entries
- [x] Verify: ch12 renders with local pkg; URL-reading code works over HTTP (local server); _book/data populated; sidebar links in HTML
- [ ] Needs Rob: push weird pkg + `make update`; deploy data/ before full render

### Review
weird pkg: senate_edges (73,802 x 3) and senate_members (7,272 x 3) tibbles, +39 KB as xz rda; tarball 1.3 MB; examples run. Not committed.
Ch12 rendered with the dev package installed into .uvr; senate-data chunk now unfolded; results identical to the live page.
URL reads (readr::read_csv / read.csv / readr::read_rds) checked against a local HTTP server: identical to local files.
other-links checked on a throwaway page. Chs 1, 10, 13 not yet rendered: the OTexts.com/weird/data/ URLs 404 until deployed.

## Ch12 senator names (2026-10-07)
- [x] us_senate_edges / us_senate_members (renamed in pkg); name column in senate_node_features; table shows 5 flagged with names
- [x] Prose names Zorinsky, Murkowski, Roth, Evans, Proxmire; Zorinsky died Mar 1987 (replaced by Karnes); guards on names + cross-party edge counts
- [x] Edge threshold 75% -> 80%; President is a node from 84th Congress (Reagan in 100th, not flagged)
- [x] Reworded "not a fluke" and "consistent with the high-betweenness senators": 100th Congress more anomalous without Zorinsky (0.0002 vs 0.0008); guard senate-zorinsky-check
- [x] Fig 12.2: flagged points labelled (ggrepel); isolated trio share one label
- [x] Murkowski: only cross-party edge is to Zorinsky; without Zorinsky btw 861 -> 268, not flagged (sentence + guard in senate-node-check)
- [x] No digit sentence starts: ch12 `r english::Words(n_flagged)`; captions ch2 (The 90% HDR), ch3 x3 (Two thousand); chs 2, 3, 12 render

## Move remaining data into weird (2026-10-07)
Decisions (Rob): fetch_pets2006() = all 1200 frames at 120x96; ch13 uses every frame 300-1200 (re-audit);
us_mortality = tidy long tibble; names us_mortality, fashion. halley_toms_ozone stays in book data/.
- [x] pkg: us_mortality (Year, Week, Sex, Age, Deaths, Mortality) from STMF CSV; data-raw/us_mortality.R; docs
- [x] pkg: fashion (move data/fashion_mnist.R to data-raw); docs
- [x] pkg: fetch_pets2006() -> tibble(frame, pixels matrix col), data-raw/pets2006.R + pets2006.rds (3.5 MB) from ~/Downloads/archive.zip; docs
- [x] pkg: pkgdown, NEWS, document, examples, tarball size
- [x] ch10: us_stmf from us_mortality; check identical to old us_stmf; drop other-links
- [x] ch13: fashion from pkg; pets2006 <- fetch_pets2006() |> filter(frame >= 300); drop other-links
- [x] ch13: re-run PETS section with 901 frames; re-audit every claim, guard, figure (frames shown, periods, cutoff counts, bag check)
- [x] book data/: keep only halley_toms_ozone.txt; trim resources; update CLAUDE.md note
- [x] Test with local pkg (fetch URL served locally until pushed); render chs 10, 13

### Review
pkg: us_mortality (10,278 x 6, 96 KB; read.csv so ch10's us_stmf is bit-identical), fashion (identical to old rds, 300 KB),
fetch_pets2006() (data-raw/pets2006.rds 3.5 MB, all 1200 frames; old 301 frames identical to rows 300,303,...). R CMD check: 0/0/0. Tarball 1.7 MB.
ch10: all printed output identical to live page. ch13: 901 frames; 150 above cutoff (23 expected); periods 670-753 (dip 682-722) and 904-1010;
shown frame 720 -> 735 (720 is in the dip); residual frames now 675, 968, 1200; all guards pass, new guard for frame 735 and the dip.
Tested fetch via temporary localhost build; real package (GitHub URL) reinstalled. Needs push of weird before ch13 renders for anyone else.

## Full review of chapters 1-13 with /review-chapter (2026-10-07, after the day's changes)
- [x] Cross-chapter checks: duplicate chunk labels, unresolved @refs, citation keys, spelling variants (all clean)
- [x] ch1-7, ch12 (committed by Rob in f1c180c)  - [x] ch6 (rest), ch8, ch9, ch10, ch11, ch13 (2026-10-08)
- [x] Merge new checklist items into .claude/commands/review-chapter.md
- [x] Re-run cross-chapter checks after edits; full `make build`; check warnings

### Review
All 13 chapters reviewed. Book builds cleanly (no warnings, no unresolved refs); new guards in ch6, ch8, ch10, ch13 pass.
Open author decisions: gun_deaths unused after ch1; Barnett1978 key holds 1994 ed.; s_mad in ch4 gap test;
ch9 PcaHubert uses MCD branch (text now explains); ch3 delta_neighbourhood.R row<col bug; symbol clashes in ch2.

## Plot fonts match the book (2026-10-16)
- [x] Text layers (annotate, geom_text, ggrepel) in Fira Sans via theme geom element
- [x] Register "BookMath" family from system fonts (fonts-katex, like Fira Sans already); clear error if missing
- [x] `tex()` helper (latex2exp -> plotmath restyled to BookMath faces), in tex-labels.R sourced by before-each-chapter.R
- [x] Convert TeX() / parse=TRUE labels: density, univariate, multivariate, tests, distance, functional, appendix
- [x] Look at every affected figure; drop ~ spacing hacks where not needed
- [x] Clean build (freeze + knitr cache keep old plots otherwise); compare all figures before/after

### Review
Clean build OK (5 min, no warnings). 40 of 164 figures changed, all checked side by side: only fonts differ
(fig-ofpot jitter re-randomised by the clean build). Text of all chapters matches the live site apart from the
tex() code change and the new ch7 sections. Bugs caught on the way: named tex() output made ggplot2 4 ignore
legend labels; numbers lost trailing zeros (0.50 -> 0.5); multi-letter subscripts (ij) upright.
Not converted: maths written as plain text in labels, e.g. "f(y)", "Q(p)", "Q(0.8)", "c=2.0", "h = 5", "c (threshold)".

## Maths labels and text size (2026-10-16, follow-up)
- [x] Plain-text maths in labels -> tex(): f(y), Q(p), p, y, x, n, m, h = 5, c = 2.0, Q(0.8), n = 100 legend
- [x] KaTeX fonts scaled 1.2 (x-height matches Fira Sans) in plot-fonts/, with generator script and MIT licence
- [x] Measured text sizes (desktop, 877px figure, 18px body): ticks ~13px (74%), titles/legends/geom_text ~17px
- [x] Rebuild, compare every figure, check text against live site

### Review
All 49 changed figures checked. Fixed: tex() names leaked from latex2exp (linetype legend), Q(0.8) label overlap,
legend order in fig-quantile-bias. Open: the two O3 plots (functional fig-o3-pca, highdim fig-o3plot) use
fig-width 14, so their text displays at ~57% of the usual size; their per-observation column labels leave no room to enlarge.

## Ch7: remaining talk suggestions (2026-10-16)
- [x] #1 Why surprisals have GPD tails (three xi cases, undergraduate level)
- [x] #2 t4 example: f* with lighter tails than the data
- [x] #3 Figure of the GPD approximation (fig-gpd-approx)
- [x] #4 Define S = -log f(Y), p_i = Pr(S >= s_i), motivating EVT; GPD only needs f* to order the extreme surprisals

## Ch11 (time series, timeseries.qmd): changes suggested by the UConn talk (2026-10-16)
Pitch everything at undergraduate level (tasks/lessons.md, 2026-10-16). Maths in plot labels via tex().
- [ ] Surveillance p-values, in "The surveillance algorithm" (l.850), not only in "Surveillance across several series":
  - [x] If the forecast distribution is correct, the p-values are uniform on (0,1) (PIT, @sec-pit); move the sentence at l.1133 here and refer back to it
  - [x] So a threshold alpha gives a false-alarm rate of alpha per series per month; use this to justify the 1-in-1000 threshold at l.1075 (84 series x 0.001 is about one false alarm a year across all series)
  - [x] ETS forecasts are Gaussian, so p is a two-sided z-test on the one-step forecast error; link to "Connection to z-scores" in ch7
- [x] Heatmap of all surveillance p-values (ATC group x month) before "Surveillance across several series" (l.1122); events hitting many groups (Feb 2008) show as vertical stripes
- [ ] Weird series (l.672): show what a feature is before the PCA, e.g. scatterplot of trend strength vs seasonal strength for the PBS series
- [ ] PC plot (fig-weirdseries_pca, l.711): add KDE HDR contours (ch7 recommends HDR displays)
- [ ] Consider `method = "lookout"` in the KDE surprisals (l.728), to use ch7's lookout bandwidth; same three series flagged (checked against the talk's targets)
- [ ] Hampel identifier (l.192): static figure for one series (e.g. males aged 25) with the band m_t +/- k a_t/0.6745 and flagged points; currently equations only
- [ ] Summary (l.1243): open with the unifying idea: all three settings use surprisal probabilities, with f the density of residuals from the signal (weird times), the KDE of the features (weird series), or the one-step forecast density (surveillance); the GPD keeps p approximately right when f is wrong
