FROM debian:buster-slim

WORKDIR /papers

# poppler-utils: pdfunite
# imagemagick: convert
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    wget \
    libpod-pom-perl \
    fontconfig \
    fonts-lmodern \
    poppler-utils \
    imagemagick \
    texlive \
    texlive-xetex \
    && rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl libssl-dev openssl && \
    rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

# Required because openssl can't be located automatically
ENV OPENSSL_INCLUDE_DIR=/usr/include
ENV OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu/
