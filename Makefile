qmd_files   := $(wildcard *.qmd)
rds_files   := $(wildcard rds/*.rds)
shared_deps := weird.bib before-each-chapter.R apa-single-spaced.csl otexts.scss _quarto.yml

.PHONY: all preview build launch deploy clean

all: build

build: _book/.built

_book/.built: $(qmd_files) $(rds_files) $(shared_deps)
	sed -i -E 's/(most_anomalous\$$price\[1\])\\`/\1`/g; s/(underpriced\$$price\[1\])\\`/\1`/g' 08-regression.qmd
	quarto render --to html
	perl -i htmlreplace.pl _book/*.html
	touch $@

launch:
	xdg-open _book/index.html

deploy: build
	cp .htaccess _book
	rsync -zrvce 'ssh -p 18765' _book/ u192-zw4zvui1lqsb@ssh.otexts.com:www/otexts.com/public_html/weird

clean:
	rm -rf _book _freeze *_cache *_files
