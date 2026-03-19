while (<>) {
  s/Retrieved from//g;
  s|>https://doi.org/10.[0-9a-zA-Z()_.:;%/-]*|>[DOI]|g;
  s|>https://arxiv.org/abs/[0-9a-zA-Z()_.:;%/-]*|>[arXiv]|g;
  s|<p class="author" style="margin: 0.5em 0 -0.5em 0;">|<p class="author">|g;
  s{(?<!<a href=['"])https://amazon.com/dp/[0-9Xx-]{10,20}}{<a href='$&'>[Amazon]</a>}g;
  print;
}