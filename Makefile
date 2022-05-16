CWD := $(shell pwd)


ifneq ($(DOCKER),true)
		PANDOC_CMD := pandoc
else
		PANDOC_CMD := docker pull pandoc/latex && docker run --rm -v ${CWD}:/data pandoc/latex
endif

.PHONY: clean pdf

FLAGS := --metadata-file=meta.yml --pdf-engine=xelatex --standalone
FILTERS := --lua-filter=filters/scholarly-metadata.lua --lua-filter=filters/author-info-blocks.lua
pdf: protocol.pdf

protocol.pdf: protocol.md default.latex
	${PANDOC_CMD} ${FLAGS} ${FILTERS} --template=default.latex --output protocol.pdf protocol.md

protocol.html: protocol.tex
	${PANDOC_CMD} ${FLAGS} --mathjax --output protocol.html protocol.tex

protocol.tex:
	${PANDOC_CMD} ${FLAGS} --output protocol.tex protocol.md


clean: 
	rm -f protocol.pdf protocol.html protocol.tex table.tex protocol.docx
