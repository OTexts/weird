qmd_files := $(wildcard *.qmd)
rds_files := $(wildcard *.rds)

default: all

all: build launch

build: $(qmd_files) $(rds_files) weird.bib before-each-chapter.R apa-single-spaced.csl otexts.scss _quarto.yml
	quarto render --to html
	perl -i htmlreplace.pl _book/*.html

launch:
	xdg-open _book/index.html

deploy:
	cp .htaccess _book
	rsync -zrvce 'ssh -p 18765' _book/ u192-zw4zvui1lqsb@ssh.otexts.com:www/otexts.com/public_html/weird

clean:
	rm -rf _book
	rm -rf _freeze
	rm -rf *_cache
	rm -rf *_files
