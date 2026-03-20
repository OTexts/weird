while (<>) {
  s/Retrieved from//g;
  s|<p class="author" style="margin: 0.5em 0 -0.5em 0;">|<p class="author">|g;
  s|>https://doi.org/10.[0-9a-zA-Z()_.:;%/-]*|>|g;
  s|>https://arxiv.org/abs/[0-9a-zA-Z()_.:;%/-]*|>|g;
  s{(?<!<a href=['"])https://amazon.com/dp/[0-9Xx-]{10,20}}{<a href='$&'></a> }g;
  s|<a\b([^>]*)>.*?</a>|<a$1></a> |g;
  print;
}
