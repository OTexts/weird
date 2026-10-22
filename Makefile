SHELL := /bin/bash

qmd_files   := $(wildcard *.qmd)
rds_files   := $(wildcard rds/*.rds)
data_files  := $(wildcard data/*)
shared_deps := weird.bib before-each-chapter.R $(wildcard _extensions/OTexts/otexts/*) _quarto.yml post-render.R .htaccess

.PHONY: all preview build launch deploy clean update

all: build

update:
	rm -rf .uvr/library/weird
	source .uvr/activate && uvr update && uvr sync

build: _book/.built

_book/.built: $(qmd_files) $(rds_files) $(data_files) $(shared_deps)
	source .uvr/activate && QUARTO_R=$$(dirname $$(command -v R)) quarto render --to otexts-html
	touch $@

preview: build
	source .uvr/activate && QUARTO_R=$$(dirname $$(command -v R)) quarto preview --to otexts-html

deploy: build
	rsync -zrvce 'ssh -p 18765' --delete _book/ u192-zw4zvui1lqsb@ssh.otexts.com:www/otexts.com/public_html/weird

clean:
	rm -rf _book _freeze *_cache *_files
