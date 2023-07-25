-include .env
REV := $(shell date +'%Y.%m.%d-' )$(shell git describe --always --dirty=-dev)
VENV := $(PWD)/.venv
DOCKER_RUN := docker run --rm -it -u $$(id -u):$$(id -g) -v "$$(pwd)":/data
MKDOCS_ARGS ?=

ifneq ($(DOCKER),true)
	PANDOC_CMD := pandoc
	MKDOCS_CMD := cd docs && $(VENV)/bin/mkdocs
else
	PANDOC_CMD := $(DOCKER_RUN) -v "$$(pwd)":/data $$(docker build -q .)
	MKDOCS_CMD := $(DOCKER_RUN) --network host \
		--entrypoint ./scripts/run-mkdocs \
		$$(docker build -q .) 
endif

FLAGS := -V "rev:$(REV)"

LATEX_FLAGS := $(FLAGS) \
	--metadata-file=meta.yml \
	--citeproc \
	--bibliography=bib/protocol.bib \
	--pdf-engine=xelatex \
	--template=tmpl/default.tex

FILTERS := \
	--lua-filter=filters/scholarly-metadata.lua \
	--lua-filter=filters/author-info-blocks.lua

SHARED_MDs := introduction.md materials.md methods.md
LATEX_MDs := $(addprefix md/,$(SHARED_MDs) latex-tables.md acknowledgements.md)
HTML_MDs := $(addprefix md/,$(SHARED_MDs) html-tables.md acknowledgements.md)

PDF := clonmapper-protocol-$(REV).pdf

bootstrap: ## setup venv for mkdocs
	@python3 -m venv $(VENV) --clear
	@$(VENV)/bin/pip install -r ./docs/requirements.txt

p pdf: $(PDF) ## generate the pdf

$(PDF): $(addprefix tex/, oligos.tex reagents.tex) $(TEMPLATE) $(LATEX_MDs)
	$(call log,Generating PDF)
	@$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS) --output $@ $(LATEX_MDs)

md/html-tables.md: tables/oligos.csv tables/reagents.csv
	@scripts/csv2mdtable tables/oligos.csv -c "Oligonucleotides" --fmt 'c,l,l,l' > md/html-tables.md
	@scripts/csv2mdtable tables/reagents.csv -c "Recommended Reagents" --fmt 'l,c,c' >> md/html-tables.md

docs/docs/protocol/%.md: md/%.md
	@cat $< | scripts/pre-mkdocs-sanitize > $@

docs/docs/full-protocol.md: $(HTML_MDs)
	@printf -- '---\nhide:\n  - navigation\n---\n' > $@
	@cat $(HTML_MDs) | scripts/pre-mkdocs-sanitize >> $@

LATEST_PDF := docs/docs/pdf/latest/$(PDF)
$(LATEST_PDF): $(PDF)
	@rm -f docs/docs/pdf/latest/*
	@cp $< $@

MKDOCS_DOCS := $(patsubst md/%.md,docs/docs/protocol/%.md, $(HTML_MDs)) \
		docs/docs/full-protocol.md

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
		-c "Oligonucleotides" \
		--split 3 \
		--fmt 'c l p{{.5\textwidth}} l' \
		--fill

tex/reagents.tex: tables/reagents.csv scripts/csv2latex
	@scripts/csv2latex \
		tables/reagents.csv \
		tex/reagents.tex \
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

.PHONY: .FORCE
.FORCE:

-include .task.cfg.mk
