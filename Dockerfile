FROM pandoc/latex:2.18

RUN tlmgr update --self && \
    tlmgr install \
    datetime2 \
    adjustbox \
    collectbox \
    tracklang

