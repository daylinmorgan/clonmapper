CWD := $(shell pwd)
REV := $(shell git rev-parse --short HEAD)
DATE := $(shell date +'%Y.%m.%d')
MD := $(shell find md -type f -name *.md | sort )

ifneq ($(DOCKER),true)
	PANDOC_CMD := pandoc
else
	PANDOC_CMD := docker run --rm -v "$(CWD)":/data -u $(id -u):$(id -g) daylinmorgan/pandoc
endif

.PHONY: clean pdf

TEMPLATE := tex/tmpl.tex

FLAGS := --metadata-file=meta.yml \
				 -V "rev:$(REV)" \
				 --pdf-engine=xelatex \
				 --standalone \
				 --citeproc \
				 --bibliography=bib/protocol.bib \
				 --csl=bib/pnas.csl \
				 --template=$(TEMPLATE)

FILTERS := --lua-filter=filters/scholarly-metadata.lua --lua-filter=filters/author-info-blocks.lua

pdf: tex/oligos.tex tex/reagents.tex $(TEMPLATE) $(MD)
	$(PANDOC_CMD) $(FLAGS) $(FILTERS)  --output protocol-$(REV).pdf md/*.md

# protocol.html: protocol.tex
# 	$(PANDOC_CMD) $(FLAGS) --mathjax --output protocol.html protocol.tex

# protocol.tex:
# 	$(PANDOC_CMD) $(FLAGS) --output protocol.tex protocol.md

tex/oligos.tex: tables/oligos.csv
	./bin/csv2latex tables/oligos.csv tex/oligos.tex -c "Oligonucleotides" --fill
tex/reagents.tex: tables/reagents.csv
	./bin/csv2latex tables/reagents.csv tex/reagents.tex -c "Recommended Reagents"

docker-build:
	docker build . --tag daylinmorgan/pandoc


clean: 
	rm -f protocol*.pdf protocol.html protocol.tex table.tex protocol.docx rev.md

