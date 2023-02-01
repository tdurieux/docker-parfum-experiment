FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends software-properties-common -y && \
    add-apt-repository ppa:fontforge/fontforge -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      fontforge \
      woff-tools \
      woff2 \
      ttfautohint \
      make \
      zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /fantasque

VOLUME /fantasque/Release

COPY . /fantasque

CMD ["make"]
