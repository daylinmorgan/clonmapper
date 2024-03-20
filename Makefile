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


PANDOC_FLAGS := \
	--data-dir data \
	--verbose \
	--metadata-file=data/meta/general.yml

LATEX_FLAGS := $(PANDOC_FLAGS) \
	--defaults latex.yml \
	--metadata-file=data/meta/latex.yml \
	-V footer-left=$(REV)

SHARED_MDs := introduction.md materials.md methods.md appendix.md
LATEX_MDs := $(addprefix md/,$(SHARED_MDs) latex-tables.md acknowledgements.md)
HTML_MDs := $(addprefix md/,$(SHARED_MDs) html-tables.md acknowledgements.md)

LATEX_TABLES := $(addprefix tex/, oligos.tex reagents.tex)
PDF := clonmapper-protocol-$(REV).pdf

bootstrap: ## setup venv for mkdocs
	@python3 -m venv $(VENV) --clear
	@$(VENV)/bin/pip install -r ./docs/requirements.txt

p pdf: $(PDF) ## generate the pdf

protocol.tex: .FORCE
	$(PANDOC_CMD) $(LATEX_FLAGS) --output $@ $(LATEX_MDs)

$(PDF): $(TEMPLATE) $(LATEX_MDs) $(LATEX_TABLES)
	$(call log,Generating PDF)
	$(PANDOC_CMD) $(LATEX_FLAGS) --output $@ $(LATEX_MDs)

md/html-tables.md: tables/oligos.csv tables/reagents.csv scripts/csv2mdtable
	@printf "## Tables" > $@
	@scripts/csv2mdtable tables/oligos.csv -t "Oligonucleotides" --fmt 'l,l,l' >> $@
	@scripts/csv2mdtable tables/reagents.csv -t "Recommended Reagents" --fmt 'l,c,c' >> $@

docs/docs/protocol.md: $(HTML_MDs) scripts/pre-mkdocs-sanitize
	@printf -- '---\nhide:\n  - navigation\n---\n' > $@
	@cat $(HTML_MDs) | scripts/pre-mkdocs-sanitize >> $@

LATEST_PDF := docs/docs/pdf/latest/$(PDF)
$(LATEST_PDF): $(PDF)
	@rm -f docs/docs/pdf/latest/*
	@cp $< $@

.PHONY: docs.build docs.content docs.serve
## docs.* |> docs.{content,serve,build}
### content -> generate website content |> --align sep
docs.content: $(LATEST_PDF) docs/docs/protocol.md
	$(call log,Generating Website Content)

### serve -> run the mkdocs live server |> --align sep
docs.serve: docs.content
	$(call log,Serving Website)
	@$(MKDOCS_CMD) serve --watch-theme $(MKDOCS_ARGS)

### build -> build the website |> --align sep
docs.build: docs.content
	@$(MKDOCS_CMD) build

# latex tables with better formatting
tex/oligos.tex: tables/oligos.csv scripts/csv2longtable
	@scripts/csv2longtable \
		tables/oligos.csv \
		tex/oligos.tex \
		--label 'oligos' \
		--caption "Oligonucleotides" \
		--oligo-column 2

tex/reagents.tex: tables/reagents.csv scripts/csv2longtable
	@scripts/csv2longtable \
		tables/reagents.csv \
		tex/reagents.tex \
		--label 'reagents' \
		--caption "Recommended Reagents" \
		--fmt 'lcc'

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

.PHONY: .FORCE
.FORCE:

.DEFAULT_GOAL := help
log = $(if $(tprint),$(call tprint,{a.bold}==> {a.magenta}$(1){a.end}),@echo '==> $(1)')
USAGE = {a.bold}{a.cyan}ClonMapper Protocol Tasks{a.end}\n\t{a.green}make{a.end}: <recipe>\n
PRINT_VARS = HTML_FLAGS LATEX_FLAGS
PHONIFY = true
-include .task.mk
$(if $(wildcard .task.mk),,.task.mk: ; curl -fsSL https://raw.githubusercontent.com/daylinmorgan/task.mk/v23.1.2/task.mk -o .task.mk)

