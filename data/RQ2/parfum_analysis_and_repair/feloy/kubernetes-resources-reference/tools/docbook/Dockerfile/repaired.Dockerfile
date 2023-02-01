FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        make \
        xsltproc \
        docbook-xsl \
        fop \
    && rm -rf /var/lib/apt/lists/*
