qmd_files   := $(wildcard *.qmd)
resources   := $(wildcard rds/*.rds data/*)
shared_deps := weird.bib before-each-chapter.R post-render.R .htaccess \
               _quarto.yml $(wildcard _extensions/OTexts/otexts/*)

.PHONY: default preview build deploy clean update

default: build

update:
	rm -rf .uvr/library/weird
	uvr update && uvr sync

preview:
	quarto preview

build: _book/.built

_book/.built: $(qmd_files) $(resources) $(shared_deps)
	quarto render --to otexts-html
	touch $@

deploy: build
	rsync -zrvc --delete -e 'ssh -p 18765' _book/ u192-zw4zvui1lqsb@ssh.otexts.com:www/otexts.com/public_html/weird
	touch .deployed

clean:
	rm -rf _book
	rm -rf _freeze
	rm -rf *_cache
	rm -rf *_files
