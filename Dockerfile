FROM pandoc/latex:2.18

RUN apk update \
  && apk add \
    bash \
    git \
    make \
    python3


RUN tlmgr update --self && \
    tlmgr install \
    datetime2 \
    adjustbox \
    collectbox \
    tracklang

