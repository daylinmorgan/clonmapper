CWD := $(shell pwd)
# REV := $(shell git rev-parse --short HEAD)
REV := $(shell git describe --always --dirty | sed s'/dirty/dev/')
DATE := $(shell date +'%Y.%m.%d')
MD := $(shell find md/ -type f -name "*.md" | sort )

ifneq ($(DOCKER),true)
	PANDOC_CMD := pandoc
else
	USER := $(shell id -u)
	GROUP := $(shell id -g)
	PANDOC_CMD := docker run --rm -v "$(CWD)":/data -u $(USER):$(GROUP) daylinmorgan/pandoc
endif


TEMPLATE := tmpl/default.tex

FLAGS := -V "rev:$(REV)" \
	--metadata-file=meta.yml \
	--standalone \
	--citeproc \
	--bibliography=bib/protocol.bib \
	--csl=bib/pnas.csl \

LATEX_FLAGS := $(FLAGS) \
	--pdf-engine=xelatex \
	--template=$(TEMPLATE)

HTML_FLAGS := $(FLAGS) \
				 --toc \
				 -t html5

FILTERS := --lua-filter=filters/scholarly-metadata.lua --lua-filter=filters/author-info-blocks.lua

.PHONY: clean pdf html

pdf: tex/oligos.tex tex/reagents.tex $(TEMPLATE) $(MD)
	$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS)  --output protocol-$(REV).pdf md/*.md

html: protocol.tex
	# $(PANDOC_CMD) $(HTML_FLAGS) $(FILTERS) --mathjax --output protocol.html protocol.tex
	$(PANDOC_CMD) $(HTML_FLAGS) $(FILTERS) --mathjax -t html5 protocol.tex | sed 's/<span>width=1.1,center=.5<\/span>//g' > protocol.html

protocol.tex: tex/oligos.tex tex/reagents.tex
	$(PANDOC_CMD) $(LATEX_FLAGS) $(FILTERS) --output protocol.tex md/*.md

tex/oligos.tex: tables/oligos.csv
	./bin/csv2latex tables/oligos.csv tex/oligos.tex -c "Oligonucleotides" --split 3 --fmt 'c l p{{.5\textwidth}} l' --fill
tex/reagents.tex: tables/reagents.csv
	./bin/csv2latex tables/reagents.csv tex/reagents.tex -c "Recommended Reagents"

docker-build:
	docker build . --tag daylinmorgan/pandoc

clean: 
	rm -f protocol*.pdf protocol.html protocol.tex table.tex protocol.docx rev.md tex/*.tex

