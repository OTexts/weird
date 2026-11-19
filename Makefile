# make, make html  render the HTML book into _book/
# make pdf         (this book has no PDF version)
# make all         render every version of the book
# make preview     preview the HTML book, re-rendering on save
# make update      update the otexts extension and the R packages (uvr.toml -> uvr.lock -> .uvr/library)
# make deploy      render the HTML book and upload it to otexts.com
# make clean       remove the rendered book and caches

qmd_files   := $(wildcard *.qmd)
resources   := $(wildcard rds/*.rds data/*)
shared_deps := weird.bib before-each-chapter.R post-render.R .htaccess \
               _quarto.yml $(wildcard _extensions/OTexts/otexts/*)

.PHONY: default all html pdf preview update deploy clean

default: html

all: html pdf

html: _book/.built

_book/.built: $(qmd_files) $(resources) $(shared_deps)
	quarto render --to otexts-html
	touch $@

pdf:
	@echo "There is no PDF version of this book"

preview:
	quarto preview --to otexts-html

update:
	quarto update extension OTexts/quarto-otexts --no-prompt
	rm -rf .uvr/library/otexts
	rm -rf .uvr/library/weird
	uvr update && uvr sync
# uvr unpacks x13binary without its executable bit, which seasonal::seas() needs
	if [ -f .uvr/library/x13binary/bin/x13ashtml ]; then chmod +x .uvr/library/x13binary/bin/x13ashtml; fi
# Some binaries (e.g. mclust) link to R's own libRblas.so, which this R (using system BLAS)
# lacks; rebuild those packages from the CRAN source of the same version
	@command -v ldd >/dev/null || exit 0; \
	tmp=$$(mktemp -d); \
	for so in .uvr/library/*/libs/*.so; do \
	  ldd "$$so" | grep -q 'libRblas.so => not found' || continue; \
	  pkg=$$(basename $$(dirname $$(dirname "$$so"))); \
	  ver=$$(sed -n 's/^Version: //p' .uvr/library/$$pkg/DESCRIPTION); \
	  echo "Rebuilding $$pkg $$ver from source (binary needs libRblas.so)"; \
	  curl -fsSL -o $$tmp/$${pkg}_$$ver.tar.gz https://cran.r-project.org/src/contrib/$${pkg}_$$ver.tar.gz || \
	  curl -fsSL -o $$tmp/$${pkg}_$$ver.tar.gz https://cran.r-project.org/src/contrib/Archive/$$pkg/$${pkg}_$$ver.tar.gz || exit 1; \
	  R CMD INSTALL --library=.uvr/library $$tmp/$${pkg}_$$ver.tar.gz || exit 1; \
	done; \
	rm -rf $$tmp

deploy: html
	rsync -zrvc --delete -e 'ssh -p 18765' _book/ u192-zw4zvui1lqsb@ssh.otexts.com:www/otexts.com/public_html/weird
	touch .deployed

clean:
	rm -rf _book
	rm -rf _freeze
	rm -rf *_cache
	rm -rf *_files
