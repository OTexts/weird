use strict;
use warnings;

local $/;  # slurp whole file

while (<>) {
  s/Retrieved from//g;
  s|<p class="author" style="margin: 0.5em 0 -0.5em 0;">|<p class="author">|g;
  # Quarto shows full titles for chapter xrefs on unnumbered pages (e.g. the preface);
  # shorten them to "Chapter N" / "Appendix A" as in the numbered chapters
  # [-@sec-...] refs (marked by otexts.lua) get the bare number or letter
  s|(<span class="xref-noprefix"><a [^>]*class="quarto-xref"><span>)(?:Appendix )?(\d+\|[A-Z])(?:&nbsp;\| —) [^<]*(</span>)|$1$2$3|g;
  s|(class="quarto-xref"><span>)(\d+)&nbsp; [^<]*(</span>)|$1Chapter $2$3|g;
  s|(class="quarto-xref"><span>)(Appendix [A-Z])[^<]*(</span>)|$1$2$3|g;
  # Link to directories, not index.html (the server redirects .../index.html to .../)
  s{(\bhref=)(["'])((?:\.\.?/|/)?(?:[^"'\s#?:]*/)?)index\.html(?=[#?"'])}{$1 . $2 . ($3 eq '' ? './' : $3)}ge;
    # Process only inside csl-entry divs
    s{(<div\b[^>]*\bclass="csl-entry"[^>]*>)(.*?)(</div>)}{
        my ($open, $inner, $close) = ($1, $2, $3);
        # Link bare Amazon URLs (the CSL prints an ISBN as one)
        $inner =~ s{(?<![\w/"'>=])https?://amazon\.com/dp/[0-9BCLXx-]{10,20}}{<a href="$&">$&</a>}gi;
        # Add affiliate tag to Amazon URLs inside <a> tags
        $inner =~ s{(<a\b[^>]*\bhref=)(["'])(https?://amazon\.com/dp/[0-9BCLXx-]{10,20})(\2)}{$1$2$3?tag=otexts-20$4}gi;
        # Unlink titles (pandoc links a title to a URL the CSL doesn't print)
        $inner =~ s|<a\b[^>]*\bhref=["']https?://[^>]*>(?!\s*(?:https?://\|www\.))(.*?)</a>|$1|gis;
        # Replace external anchors with bare anchors
        $inner =~ s|<a\b[^>]*\bhref=([\"'])(https?://[^\"'<>\s]+)\1[^>]*>.*?</a>|<a href="$2"><i class="bi bi-box-arrow-up-right"></i></a>|gi;
        # Strip text from doc-biblioref anchors
        $inner =~ s|<a\b([^>]*\brole="doc-biblioref"[^>]*)>.*?</a>|<a$1><i class="bi bi-box-arrow-up-right"></i></a>|gi;
        "$open$inner$close"
    }gse;
    print;
}
