FROM pandoc/latex:2.18-ubuntu

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

