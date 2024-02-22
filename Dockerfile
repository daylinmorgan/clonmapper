FROM pandoc/latex@sha256:9b50f44bde0cdf385f24556cf45f9ffa63f9eb3c8913a0104eaca3fc72990397

RUN apt-get update && \
      apt-get install -y \
      git \
      make \
      texlive \
      latexmk \
      python3 \
      python3-pip

RUN tlmgr update --self && \
      tlmgr install \
      datetime2 \
      adjustbox \
      collectbox \
      footmisc \
      tracklang

COPY docs/requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt
