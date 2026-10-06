SHELL := /bin/bash

qmd_files   := $(wildcard *.qmd)
rds_files   := $(wildcard rds/*.rds)
shared_deps := weird.bib before-each-chapter.R apa-single-spaced.csl otexts.scss _quarto.yml htmlreplace.pl

.PHONY: all preview build launch deploy clean update

all: build

update:
	rm -rf .uvr/library/weird
	source .uvr/activate && uvr update && uvr sync

build: _book/.built

_book/.built: $(qmd_files) $(rds_files) $(shared_deps)
	source .uvr/activate && QUARTO_R=$$(dirname $$(command -v R)) quarto render --to html
	perl -i htmlreplace.pl _book/*.html
	# Reduce figures to 256 colours; pngquant leaves a file unchanged (exit 98/99)
	# if the result would be larger or below the quality floor
	find _book -path '*_files/figure-html/*.png' -print0 | \
	  xargs -0 -P8 -I{} sh -c 'pngquant --force --ext .png --skip-if-larger --quality=80-100 "$$1"; \
	    s=$$?; [ $$s -eq 0 ] || [ $$s -eq 98 ] || [ $$s -eq 99 ]' _ {}
	touch $@

preview: build
	source .uvr/activate && QUARTO_R=$$(dirname $$(command -v R)) quarto preview --to html

deploy: build
	cp .htaccess _book
	rsync -zrvce 'ssh -p 18765' _book/ u192-zw4zvui1lqsb@ssh.otexts.com:www/otexts.com/public_html/weird

clean:
	rm -rf _book _freeze *_cache *_files
