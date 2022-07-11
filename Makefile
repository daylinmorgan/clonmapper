CWD := $(shell pwd)
REV := $(shell date +'%Y.%m.%d-' )$(shell git describe --always --dirty | sed s'/dirty/dev/')
MD := $(shell find md/ -type f -name "*.md" | sort )

ifneq ($(DOCKER),true)
	PANDOC_CMD := pandoc
else
	PANDOC_CMD := docker run --rm -v "$$(pwd)":/data -u $$(id -u):$$(id -g) daylinmorgan/pandoc
endif

FLAGS := -V "rev:$(REV)" \
	--metadata-file=meta.yml \
	--citeproc \
	--bibliography=bib/protocol.bib \
	--csl=bib/pnas.csl \

LATEX_FLAGS := $(FLAGS) \
	--pdf-engine=xelatex \
	--template=tmpl/default.tex

HTML_FLAGS := $(FLAGS) \
				 -t html5

FILTERS := --lua-filter=filters/scholarly-metadata.lua --lua-filter=filters/author-info-blocks.lua

.PHONY: clean pdf html site

pdf: protocol-$(REV).pdf

protocol-$(REV).pdf: tex/oligos.tex tex/reagents.tex $(TEMPLATE) $(MD)
	$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS)  --output protocol-$(REV).pdf md/*.md

html: protocol.tex
	$(PANDOC_CMD) $(HTML_FLAGS) $(FILTERS) --mathjax --template=tmpl/default.html protocol.tex | sed 's/<span>width=.*,center=.*<\/span>//g' > protocol.html

site: protocol-$(REV).pdf
	$(PANDOC_CMD) -s -o public/index.html site/index.md
	cp protocol-$(REV).pdf public/clonmapper-protocol-$(REV).pdf
	cd public && ln -sf ./clonmapper-protocol-$(REV).pdf ./protocol.pdf

protocol.tex: tex/oligos.tex tex/reagents.tex
	$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS) --output protocol.tex md/*.md

tex/oligos.tex: tables/oligos.csv
	./bin/csv2latex tables/oligos.csv tex/oligos.tex -c "Oligonucleotides" --split 3 --fmt 'c l p{{.5\textwidth}} l' --fill
tex/reagents.tex: tables/reagents.csv
	./bin/csv2latex tables/reagents.csv tex/reagents.tex -c "Recommended Reagents" --fmt 'l c c'

docker-build:
	docker build . --tag daylinmorgan/pandoc

clean: 
	rm -f protocol*.pdf protocol.html protocol.tex table.tex protocol.docx rev.md tex/*.tex

