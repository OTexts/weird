use strict;
use warnings;

# Define the icon
my $SYMBOL_DEF = '<svg aria-hidden="true" style="position:absolute;width:0;height:0;overflow:hidden">'
               . '<symbol id="extlink-icon" viewBox="0 0 24 24">'
               . '<path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6m4-3h6v6m-11 5L21 3" '
               . 'fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>'
               . '</symbol>'
               . '</svg>';
my $ICON = '<svg aria-hidden="true" width="16" height="16" viewBox="0 0 24 24" '
         . 'style="vertical-align: -0.05em; margin-left: 0.1em;">'
         . '<use href="#extlink-icon"/>'
         . '</svg>';
my $inserted_symbol = 0;

sub link_title {
  my ($url) = @_;
  return 'DOI'    if $url =~ m{^https?://doi\.org/10\.}i;
  return 'arXiv'  if $url =~ m{^https?://arxiv\.org/abs/}i;
  return 'Amazon' if $url =~ m{^https?://(?:www\.)?amazon\.com/dp/}i;
  return 'JSTOR'  if $url =~ m{^https?://www\.jstor\.org/stable/}i;
  return 'Link';
}

sub make_icon_link {
  my ($url) = @_;
  my $t = link_title($url);
  return qq{<a href="$url" title="$t" aria-label="$t">$ICON</a>};
}

# Turn a bare URL into (icon link + trailing punctuation)
sub linkify_bare_url {
  my ($raw) = @_;
  my $trail = '';
  # Peel off common trailing punctuation that typically follows URLs in prose.
  if ($raw =~ s/([\)\]\}\.\,\;\:\!\?]+)$//) {
    $trail = $1;
  }
  return make_icon_link($raw) . $trail;
}

while (<>) {
  # Insert the symbol definition once (prefer end of <head>, otherwise after <body ...>)
  if (!$inserted_symbol) {
    if (m{</head>}i) {
      s{</head>}{$SYMBOL_DEF\n</head>}i;
      $inserted_symbol = 1;
    } elsif (m{<body\b[^>]*>}i) {
      s{(<body\b[^>]*>)}{$1\n$SYMBOL_DEF}i;
      $inserted_symbol = 1;
    }
  }
  # Remove boilerplate phrase
  s/Retrieved from\s*//g;
  # Normalize author <p>
  s|<p class="author" style="margin: 0.5em 0 -0.5em 0;">|<p class="author">|g;

  # 1) Replace any existing external anchor (<a ... href="http(s)://...">...</a>) with icon-only link
  # Note: line-based; if an <a> spans multiple lines, it won't be matched.
  s{<a\b[^>]*\bhref=(['"])(https?://[^'"<>\s]+)\1[^>]*>.*?</a>}{make_icon_link($2)}gei;

  # 2) Wrap remaining bare external URLs in text.
  # Guard (?<![="']) avoids matching URLs inside attributes (href="...", src="...", etc.).
  s{(?<![="'])(\bhttps?://[^\s<>'"]+)}{linkify_bare_url($1)}ge;

  print;
}
