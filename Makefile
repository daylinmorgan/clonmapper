CWD := $(shell pwd)

ifneq ($(DOCKER),true)
		PANDOC_CMD := pandoc
else
		PANDOC_CMD := docker pull pandoc/latex && docker run --rm -v ${CWD}:/data pandoc/latex
endif


protocol.pdf:
	${PANDOC_CMD} --pdf-engine=xelatex -o protocol.pdf protocol.md

protocol.html: protocol.tex
	${PANDOC_CMD} --standalone --mathjax -o protocol.html protocol.tex

protocol.tex:
	${PANDOC_CMD} --pdf-engine xelatex -o protocol.tex protocol.md --pdf-engine xelatex

.PHONY: clean

clean:
	rm -f protocol.pdf protocol.html protocol.tex table.tex
