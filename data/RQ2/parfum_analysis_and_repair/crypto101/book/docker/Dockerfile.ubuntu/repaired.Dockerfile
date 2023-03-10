FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
    git \
    graphviz \
    latexmk \
    make \
    potrace \
    texlive-latex-recommended \
    texlive-metapost \
    texlive-xetex \
    texlive-latex-extra \
    context \
    pdf2svg \
    python3-sphinx \
    sphinx-intl \
    python3-stemmer \
    python3-sphinxcontrib.bibtex \
    python3-sphinxcontrib.svg2pdfconverter \
    ghostscript \
    xindy && rm -rf /var/lib/apt/lists/*;

RUN set -e; \
    apt-get install --no-install-recommends -y wget; rm -rf /var/lib/apt/lists/*; \
    for archive in source-code-pro/archive/2.030R-ro/1.050R-it.zip \
                   source-serif-pro/archive/2.000R.zip \
                   source-sans-pro/archive/2.020R-ro/1.075R-it.zip; do \
        wget -O archive.zip https://github.com/adobe-fonts/"${archive}"; \
        unzip -j archive.zip '*.otf' -d /usr/local/share/fonts; \
        rm archive.zip; \
    done; \
    fc-cache -f -v

# setup texlive to handle having no home directory
ENV TEXMFVAR /tmp/texmf-var
ENV TEXMFCACHE /tmp/texmf-cache

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

WORKDIR /repo
