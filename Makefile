REV := $(shell date +'%Y.%m.%d-' )$(shell git describe --always --dirty | sed s'/dirty/dev/')

ifneq ($(DOCKER),true)
	PANDOC_CMD := pandoc
else
	PANDOC_CMD := docker run --rm -v "$$(pwd)":/data -u $$(id -u):$$(id -g) daylinmorgan/pandoc
endif

FLAGS := -V "rev:$(REV)" \
	--citeproc \
	--bibliography=bib/protocol.bib \
	--csl=bib/pnas.csl

LATEX_FLAGS := $(FLAGS) \
	--metadata-file=meta.yml \
	--pdf-engine=xelatex \
	--template=tmpl/default.tex

HTML_FLAGS := $(FLAGS) \
				--mathjax \
				--template=tmpl/default.html \
				--css ./site/css/tufte.css

MD_FLAGS := -t commonmark+footnotes+tex_math_dollars

FILTERS := --lua-filter=filters/scholarly-metadata.lua \
			--lua-filter=filters/author-info-blocks.lua

SHARED_MDs := introduction.md materials.md methods.md
LATEX_MDs := $(addprefix md/,$(SHARED_MDs) latex-tables.md acknowledgements.md)
HTML_MDs := $(addprefix md/,$(SHARED_MDs) html-tables.md acknowledgements.md)

PDF := clonmapper-protocol-$(REV).pdf

## p pdf | generate the pdf
.PHONY: p pdf
p pdf: $(PDF)

$(PDF): $(addprefix tex/, oligos.tex reagents.tex) $(TEMPLATE) $(LATEX_MDs)
	@echo "==> Generating PDF <=="
	@$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS) --output $@ $(LATEX_MDs)

md/html-tables.md:
	@./bin/csv2mdtable tables/oligos.csv -c "Oligonucleotides" --fmt 'c,l,l,l' > md/html-tables.md
	@./bin/csv2mdtable tables/reagents.csv -c "Recommended Reagents" --fmt 'l,c,c' >> md/html-tables.md

site/content/protocol/%.md: md/%.md site/meta/%.md
	@cat site/meta/$*.md > $@
	@$(PANDOC_CMD) $(FLAGS) $(MD_FLAGS) -s \
		 $< >> $@

site/content/single-page-protocol.md: $(HTML_MDs)
	@cat site/meta/single-page-protocol.md > $@
	@$(PANDOC_CMD) $(FLAGS) $(MD_FLAGS) \
		 $(HTML_MDs) >> $@

SITE_PDF := site/static/pdfs/latest/$(PDF)

$(SITE_PDF): $(PDF)
	@mkdir -p site/static/pdfs/latest/
	@rm -f site/static/pdfs/latest/*
	@cp $< $@

LATEST_DATA := site/data/latest.toml

.PHONY: $(LATEST_DATA)
$(LATEST_DATA):
	@printf "%s\n" \
		"revision = \"$(REV)\"" \
		"file = \"$(PDF)\"" > $@

CONTENT := $(patsubst md/%.md,site/content/protocol/%.md,$(HTML_MDs)) \
		site/content/single-page-protocol.md

## site | site.<recipes>
### content -> generate website content 
.PHONY: site.content
site.content: $(SITE_PDF) $(CONTENT) $(LATEST_DATA)
	@echo "==> Generating Website Content <=="

### serve -> run the hugo server
.PHONY: site.serve
site.serve: site.content
	@echo "==> Serving Website <=="
	cd site && hugo server -D --minify --disableFastRender

### build -> build the website
.PHONY: website.build
site.build: site.content
	cd site && hugo --minify

# latex tables with better formatting
tex/oligos.tex: tables/oligos.csv bin/csv2latex
	@./bin/csv2latex \
		tables/oligos.csv \
		tex/oligos.tex \
		-c "Oligonucleotides" \
		--split 3 \
		--fmt 'c l p{{.5\textwidth}} l' \
		--fill

tex/reagents.tex: tables/reagents.csv bin/csv2latex
	@./bin/csv2latex \
		tables/reagents.csv \
		tex/reagents.tex \
		-c "Recommended Reagents" \
		--fmt 'l c c'

.PHONY: docker-build c clean clean.site clean.paper

## docker | build docker container to run pandoc locally
docker:
	docker build . --tag daylinmorgan/pandoc

## c, clean | runs clean.paper clean.website
### paper -> remove paper outputs
### website -> remove website outpurs
c clean: clean.paper clean.site

clean.paper:
	rm -f protocol*.pdf \
			clonmapper-protocol*.pdf \
			protocol.html \
			protocol.tex \
			public/*

clean.site:
	rm -f $(patsubst md/%,site/content/protocol/%, $(HTML_MDs)) \
			site/content/single-page-protocol.md \
			site/static/pdfs/latest/* \
			$(LATEST_DATA)
## flags | show current pandoc flags
.PHONY: flags
flags:
	@printf "\033[35mCurrent Flags\033[0m:\n\n"
	@printf "\033[34m%s\033[0m:\n" "HTML_FLAGS"
	@printf "\t%s\n" $(HTML_FLAGS)
	@printf "\033[34m%s\033[0m:\n" "LATEX_FLAGS"
	@printf "\t%s\n" $(LATEX_FLAGS)


	@printf "\n"


.DEFAULT_GOAL := help
## h, help | show this help
.PHONY: help h
help h: Makefile params
	@awk -v fill=$(shell sed -n 's/^## \(.*\) | .*/\1/p' $< | wc -L)\
  	'match($$0,/^## (.*) \|/,name) && match($$0,/\| (.*)$$/,help)\
		{printf "\033[1;93m%*s\033[0m | \033[30m%s\033[0m\n",\
    fill,name[1],help[1];} match($$0,/^### (.*)/,str) \
	{printf "%*s   \033[30m%s\033[0m\n",fill," ",str[1];}' $<

.PHONY: params
params:
	@printf "\033[1;97;40mClonMapper Protocol\033[0m\n"
	@printf "\033[35mCurrent Params\033[0m:\n\n"
	@printf "  REV: %s\n" $(REV)
	@printf "\n"
