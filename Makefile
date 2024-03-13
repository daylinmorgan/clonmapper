-include .env
REV ?= $(shell date +'%Y.%m.%d-' )$(shell git describe --always --dirty=-dev)
VENV := $(PWD)/.venv
DOCKER_RUN := docker run --rm -it -u $$(id -u):$$(id -g) -v "$$(pwd)":/data
MKDOCS_ARGS ?=

ifneq ($(DOCKER),true)
	PANDOC_CMD := pandoc
	MKDOCS_CMD := cd docs && $(VENV)/bin/mkdocs
else
	PANDOC_CMD := $(DOCKER_RUN) -v "$$(pwd)":/data $$(docker build -q .) pandoc
	MKDOCS_CMD := $(DOCKER_RUN) --network host \
		--entrypoint ./scripts/run-mkdocs \
		$$(docker build -q .)
endif

FLAGS := -V "rev:$(REV)"

LATEX_FLAGS := $(FLAGS) \
	--metadata-file=meta.yml \
	--citeproc \
	--bibliography=bib/protocol.bib \
	--pdf-engine=lualatex \
	--template=templates/default.tex \
	--verbose

FILTERS := \
	--lua-filter=filters/scholarly-metadata.lua \
	--lua-filter=filters/author-info-blocks.lua

SHARED_MDs := introduction.md materials.md methods.md appendix.md
LATEX_MDs := $(addprefix md/,$(SHARED_MDs) latex-tables.md  acknowledgements.md)

HTML_MDs := $(addprefix md/,$(SHARED_MDs) html-tables.md acknowledgements.md)
LATEX_TABLES := $(addprefix tex/, oligos.tex reagents.tex)
PDF := clonmapper-protocol-$(REV).pdf

bootstrap: ## setup venv for mkdocs
	@python3 -m venv $(VENV) --clear
	@$(VENV)/bin/pip install -r ./docs/requirements.txt

p pdf: $(PDF) ## generate the pdf

protocol.tex: .FORCE
	$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS) --output $@ $(LATEX_MDs)

$(PDF): $(TEMPLATE) $(LATEX_MDs) $(LATEX_TABLES)
	$(call log,Generating PDF)
	$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS) --output $@ $(LATEX_MDs)

md/html-tables.md: tables/oligos.csv tables/reagents.csv
	@scripts/csv2mdtable tables/oligos.csv -c "Oligonucleotides" --fmt 'c,l,l,l' > $@
	@scripts/csv2mdtable tables/reagents.csv -c "Recommended Reagents" --fmt 'l,c,c' >> $@

docs/docs/protocol/%.md: md/%.md
	@cat $< | scripts/pre-mkdocs-sanitize > $@

docs/docs/protocol/html-tables.md: md/html-tables.md
	@echo "# Tables" > $@
	@cat $< | scripts/pre-mkdocs-sanitize >> $@

docs/docs/protocol.md: $(HTML_MDs) scripts/pre-mkdocs-sanitize
	@printf -- '---\nhide:\n  - navigation\n---\n' > $@
	@cat $(HTML_MDs) | scripts/pre-mkdocs-sanitize >> $@

LATEST_PDF := docs/docs/pdf/latest/$(PDF)
$(LATEST_PDF): $(PDF)
	@rm -f docs/docs/pdf/latest/*
	@cp $< $@

# MKDOCS_DOCS := $(patsubst md/%.md,docs/docs/protocol/%.md, $(HTML_MDs)) \
# 		docs/docs/full-protocol.md
MKDOCS_DOCS = docs/docs/protocol.md

.PHONY: docs.build docs.content docs.serve
## docs.* |> docs.{content,serve,build}
### content -> generate website content |> --align sep
docs.content: $(LATEST_PDF) $(MKDOCS_DOCS)
	$(call log,Generating Website Content)

### serve -> run the mkdocs live server |> --align sep
docs.serve: docs.content
	$(call log,Serving Website)
	@$(MKDOCS_CMD) serve --watch-theme $(MKDOCS_ARGS)

### build -> build the website |> --align sep
docs.build: docs.content
	@$(MKDOCS_CMD) build

# latex tables with better formatting
tex/oligos.tex: tables/oligos.csv scripts/csv2latex
	@scripts/csv2latex \
		tables/oligos.csv \
		tex/oligos.tex \
		--label 'oligos' \
		-c "Oligonucleotides" \
		--split 3 \
		--fmt 'c l p{{.5\textwidth}} l' \
		--fill

tex/reagents.tex: tables/reagents.csv scripts/csv2latex
	@scripts/csv2latex \
		tables/reagents.csv \
		tex/reagents.tex \
		--label 'reagents' \
		-c "Recommended Reagents" \
		--fmt 'l c c'


docker: ## build docker container to run pandoc locally
	docker build . --tag daylinmorgan/pandoc

.PHONY: clean.site clean.paper
## c, clean |> clean.{paper,docs} 
### paper -> remove paper outputs |> --align sep
### docs -> remove mkdocs outputs |> --align sep
c clean: clean.paper clean.docs

clean.paper:
	@rm -f protocol*.pdf \
			clonmapper-protocol*.pdf \
			protocol.html \
			protocol.tex \
			public/*

clean.docs:
	@rm -f $(patsubst md/%,docs/docs/protocol/%, $(HTML_MDs)) \
			docs/docs/full-protocol.md \
			docs/docs/pdf/latest/*.pdf
	@rm -rf docs/site

templates/default.tex: templates/preamble.patch
	pandoc -D latex > templates/default.tex
	patch -u -b templates/default.tex -i templates/preamble.patch

templates/preamble.patch:
	pandoc -D latex > templates/default.latex
	diff -u templates/default.latex templates/default.tex > templates/preamble.patch || true

.PHONY: .FORCE
.FORCE:

.DEFAULT_GOAL := help
log = $(if $(tprint),$(call tprint,{a.bold}==> {a.magenta}$(1){a.end}),@echo '==> $(1)')
USAGE = {a.bold}{a.cyan}ClonMapper Protocol Tasks{a.end}\n\t{a.green}make{a.end}: <recipe>\n
PRINT_VARS = HTML_FLAGS LATEX_FLAGS
PHONIFY = true
-include .task.mk
$(if $(wildcard .task.mk),,.task.mk: ; curl -fsSL https://raw.githubusercontent.com/daylinmorgan/task.mk/v23.1.2/task.mk -o .task.mk)

