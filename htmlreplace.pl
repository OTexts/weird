use strict;
use warnings;

local $/;  # slurp whole file

while (<>) {
  s/Retrieved from//g;
  s|<p class="author" style="margin: 0.5em 0 -0.5em 0;">|<p class="author">|g;
  s{(?<!<a href=['"])https://amazon.com/dp/[0-9BCLXx-]{10,20}}{<a href='$&'>[Amazon]</a>}g;
    # Process only inside csl-entry divs
    s{(<div\b[^>]*\bclass="csl-entry"[^>]*>)(.*?)(</div>)}{
        my ($open, $inner, $close) = ($1, $2, $3);
        # Replace external anchors with bare anchors
        $inner =~ s|<a\b[^>]*\bhref=([\"'])(https?://[^\"'<>\s]+)\1[^>]*>.*?</a>|<a href="$2"><i class="fa-solid fa-up-right-from-square"></i></a>|gi;
        # Strip text from doc-biblioref anchors
        $inner =~ s|<a\b([^>]*\brole="doc-biblioref"[^>]*)>.*?</a>|<a$1><i class="fa-solid fa-up-right-from-square"></i></a>|gi;
        "$open$inner$close"
    }gse;
    print;
}
