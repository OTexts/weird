# Maths in plot labels, set in the same fonts that KaTeX uses for maths in the
# book text: variables in KaTeX_Math italic, and digits and brackets in
# KaTeX_Main. Ordinary text in a label stays in Fira Sans.
#
# Plotmath cannot switch font family within a label, but it can switch face.
# So the "BookMath" family has a different font for each face:
#   plain      Fira Sans              text, e.g. "Contours of"
#   bold       KaTeX_Main Regular     digits, brackets, upper-case Greek
#   italic     KaTeX_Math Italic      variables and lower-case Greek
#   bolditalic KaTeX_Math BoldItalic  vectors, as \bm{v} in the text
# tex() converts LaTeX to plotmath with latex2exp::TeX(), then puts each part
# of the maths in the right face. The chunks call TeX(), which is defined at
# the end of this file as tex(), so readers can run the same code with
# latex2exp::TeX() and get the same labels in default fonts. Write vectors in
# plot labels as \textbf{v}, which plain TeX() sets in bold; tex() sets them in
# bold italic, as \bm{v} in the text.
# BookMath is the family for theme text and text layers (before-each-chapter.R).
# Don't use it for bold or italic text, as those faces are KaTeX fonts: text
# layers with fontface = "bold" need family = "Fira Sans".
#
# The KaTeX fonts are copies scaled up by 1.2 to match Fira Sans, in
# plot-fonts/ (see make_plot_fonts.py there). Fira Sans must be installed.

local({
  fira <- systemfonts::match_fonts("Fira Sans")$path
  if (systemfonts::font_info(path = fira)$family != "Fira Sans") {
    stop("Font 'Fira Sans' is not installed; it is used for text in plots")
  }
  katex <- function(file) here::here("plot-fonts", paste0(file, ".ttf"))
  # Registered afresh each time, so a change to the font files is picked up
  systemfonts::register_font(
    name = "BookMath",
    plain = fira,
    bold = katex("KaTeX_Main_Plot-Regular"),
    italic = katex("KaTeX_Math_Plot-Italic"),
    bolditalic = katex("KaTeX_Math_Plot-BoldItalic")
  )
})

tex_greek <- c(
  alpha = "α", beta = "β", gamma = "γ", delta = "δ",
  epsilon = "ε", zeta = "ζ", eta = "η", theta = "θ",
  iota = "ι", kappa = "κ", lambda = "λ", mu = "μ",
  nu = "ν", xi = "ξ", pi = "π", rho = "ρ",
  sigma = "σ", tau = "τ", upsilon = "υ", phi = "φ",
  chi = "χ", psi = "ψ", omega = "ω",
  Gamma = "Γ", Delta = "Δ", Theta = "Θ", Lambda = "Λ",
  Xi = "Ξ", Pi = "Π", Sigma = "Σ", Phi = "Φ",
  Psi = "Ψ", Omega = "Ω"
)

# Plotmath functions, which are kept with only their arguments restyled
tex_plotmath_fns <- c(
  "[", "^", "*", "~", "{", "(", "paste", "hat", "widehat", "bar", "tilde",
  "widetilde", "dot", "ring", "phantom", "frac", "over", "sqrt", "group",
  "bgroup", "==", "!=", "<", ">", "<=", ">=", "+", "-", "/", "%+-%", "%*%",
  "%.%", "%~~%", "%==%", "%prop%", "%->%", "%in%", "plain", "bold", "italic",
  "bolditalic", "textstyle", "displaystyle", "scriptstyle", "underline", "atop",
  "symbol"
)

# Plotmath symbols, which are left as they are
tex_plotmath_symbols <- c(
  "infinity", "partialdiff", "nabla", "cdots", "ldots", "degree", "minute",
  "second", "aleph", "varepsilon", "vartheta", "varphi", "varsigma", "Upsilon1",
  "omega1", "theta1", "phi1", "sigma1"
)

tex_restyle <- function(e) {
  # Join terms with commas set in KaTeX_Main
  commas <- function(args) {
    Reduce(function(a, b) call("*", call("*", a, quote(bold(","))), b), args)
  }
  if (is.character(e)) {
    e # text
  } else if (is.numeric(e)) {
    call("bold", format(e))
  } else if (is.name(e)) {
    nm <- as.character(e)
    if (nm %in% names(tex_greek)) {
      # KaTeX sets lower-case Greek in italic and capitals upright
      call(
        if (nm == tolower(nm)) "italic" else "bold",
        unname(tex_greek[nm])
      )
    } else if (grepl("^[A-Za-z]+$", nm) && !nm %in% tex_plotmath_symbols) {
      # Letters, including runs such as the ij in beta[ij]
      call("italic", nm)
    } else {
      e
    }
  } else if (is.call(e)) {
    # The function may itself be a call, as in hat(g)(s)
    fn <- if (is.name(e[[1]])) as.character(e[[1]]) else ""
    args <- as.list(e)[-1]
    empty <- vapply(args, \(a) identical(a, quote(expr = )), logical(1))
    args <- lapply(args[!empty], tex_restyle)
    if (fn == "bolditalic") {
      e # a vector, from \bm{}: leave its letters in bold italic
    } else if (fn == "list") {
      # latex2exp writes the comma in y_{1,5} as list(,)
      if (length(args) == 0) quote(bold(",")) else call("{", commas(args))
    } else if (fn %in% tex_plotmath_fns) {
      as.call(c(e[[1]], args))
    } else {
      # A function such as f(y): brackets in KaTeX_Main. Products are grouped
      # with invisible braces, as plotmath otherwise shows a product on the
      # right of another product in brackets.
      call(
        "{",
        call(
          "*",
          call(
            "*",
            call("*", tex_restyle(e[[1]]), quote(bold("("))),
            call("{", commas(args))
          ),
          quote(bold(")"))
        )
      )
    }
  } else {
    e
  }
}

# Numbers in the maths (outside quoted text) as strings in KaTeX_Main, so they
# are shown as written: parsing 0.50 as a number would show it as 0.5
tex_quote_numbers <- function(s) {
  # Split at quoted strings; the odd-numbered pieces are maths
  parts <- regmatches(s, gregexpr("'[^']*'|\"[^\"]*\"", s), invert = NA)[[1]]
  maths <- seq(1, length(parts), by = 2)
  parts[maths] <- gsub(
    "(?<![A-Za-z0-9_.])([0-9]+(\\.[0-9]+)?)",
    "bold('\\1')",
    parts[maths],
    perl = TRUE
  )
  paste(parts, collapse = "")
}

# Drop-in replacement for latex2exp::TeX(); output = "character" gives strings
# for layers with parse = TRUE
tex <- function(input, output = c("expression", "character")) {
  output <- match.arg(output)
  # Unnamed, as ggplot2 matches named scale labels to breaks by name
  plotmath <- unname(latex2exp::TeX(
    input,
    user_defined = list(
      "\\bm" = "bolditalic($arg1)",
      "\\textbf" = "bolditalic($arg1)"
    ),
    output = "character"
  ))
  exprs <- lapply(plotmath, function(s) {
    tex_restyle(str2lang(tex_quote_numbers(s)))
  })
  if (output == "character") {
    vapply(exprs, deparse1, character(1))
  } else {
    as.expression(exprs)
  }
}

# The chunks call TeX(), so the code shown also runs with latex2exp::TeX()
TeX <- tex
