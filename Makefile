CWD := $(shell pwd)
REV := $(shell git rev-parse --short HEAD)
DATE := $(shell date +'%Y.%m.%d')

ifneq ($(DOCKER),true)
		PANDOC_CMD := pandoc
else
		# PANDOC_CMD := docker pull pandoc/latex && docker run --rm -v ${CWD}:/data pandoc/latex
		PANDOC_CMD := docker run --rm -v "${CWD}":/data rstropek/pandoc-latex
endif

.PHONY: clean pdf

TEMPLATE := tex/tmpl.tex

FLAGS := --metadata-file=meta.yml \
				 --pdf-engine=xelatex \
				 --standalone \
				 --citeproc \
				 --bibliography=bib/protocol.bib \
				 --csl=bib/pnas.csl
				 --template=${TEMPLATE}

FILTERS := --lua-filter=filters/scholarly-metadata.lua --lua-filter=filters/author-info-blocks.lua

pdf: protocol.md tex/oligos.tex ${TEMPLATE} rev.md
	${PANDOC_CMD} ${FLAGS} ${FILTERS}  --output protocol-${REV}.pdf rev.md protocol.md

protocol.html: protocol.tex
	${PANDOC_CMD} ${FLAGS} --mathjax --output protocol.html protocol.tex

protocol.tex:
	${PANDOC_CMD} ${FLAGS} --output protocol.tex protocol.md

tex/oligos.tex: tables/oligos.csv
	./bin/csv2latex tables/oligos.csv tex/oligos.tex "Oligonucleotides"

rev.md: protocol.md
	echo -e "\nRev.${REV} | Updated: ${DATE}\n" > rev.md

clean: 
	rm -f protocol*.pdf protocol.html protocol.tex table.tex protocol.docx rev.md

