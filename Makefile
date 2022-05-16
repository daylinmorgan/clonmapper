CWD := $(shell pwd)


ifneq ($(DOCKER),true)
		PANDOC_CMD := pandoc
else
		# PANDOC_CMD := docker pull pandoc/latex && docker run --rm -v ${CWD}:/data pandoc/latex
		PANDOC_CMD := docker run --rm -v "${CWD}":/data rstropek/pandoc-latex
endif

.PHONY: clean pdf

TEMPLATE := tex/tmpl.tex
# TEMPLATE := eisvogel.tex

FLAGS := --metadata-file=meta.yml \
				 --pdf-engine=xelatex \
				 --standalone \
				 --citeproc \
				 --bibliography=bib/protocol.bib \
				 --csl=bib/pnas.csl
				 --template=${TEMPLATE}

FILTERS := --lua-filter=filters/scholarly-metadata.lua --lua-filter=filters/author-info-blocks.lua

pdf: protocol.pdf

protocol.pdf: protocol.md tex/table.tex ${TEMPLATE}
	${PANDOC_CMD} ${FLAGS} ${FILTERS}  --output protocol.pdf protocol.md

protocol.html: protocol.tex
	${PANDOC_CMD} ${FLAGS} --mathjax --output protocol.html protocol.tex

protocol.tex:
	${PANDOC_CMD} ${FLAGS} --output protocol.tex protocol.md

tex/table.tex: table/table.csv
	./table/csv2latex.py

clean: 
	rm -f protocol.pdf protocol.html protocol.tex table.tex protocol.docx
