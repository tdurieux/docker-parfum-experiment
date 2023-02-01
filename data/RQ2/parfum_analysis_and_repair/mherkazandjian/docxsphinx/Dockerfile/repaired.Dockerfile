FROM ubuntu:xenial

RUN \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    software-properties-common \
    python3-pip \
    git && rm -rf /var/lib/apt/lists/*;

RUN \
  pip3 install --no-cache-dir \
    docutils==0.15 \
    sphinx==1.6.2 \
    python-docx==0.8.6 \
    sphinx-bootstrap-theme==0.6.4 \
    sphinxcontrib-websupport==1.0.1 \
    git+https://github.com/mherkazandjian/docxsphinx.git@master

RUN apt-get clean

ENTRYPOINT ["make", "docx", "html"]
