FROM pandoc/latex:2.19.2-ubuntu

RUN apt-get update && \
      apt-get install -y \
      git \
      make \
      python3

RUN tlmgr update --self && \
      tlmgr install \
      datetime2 \
      adjustbox \
      collectbox \
      tracklang

