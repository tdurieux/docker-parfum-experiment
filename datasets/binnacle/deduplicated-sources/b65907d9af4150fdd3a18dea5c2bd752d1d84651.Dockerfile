FROM ubuntu:xenial

ARG AUTHOR

LABEL AUTHOR=${AUTHOR}

RUN apt-get update && apt-get install -y --no-install-recommends \
        make \
        build-essential \
        git \
        patch && \
    rm -rf /var/lib/apt/lists/*

ARG USER_ID
RUN useradd --non-unique --uid $USER_ID build

WORKDIR /src/hashcat

COPY files/hashcat_shared.patch .
COPY external/hashcat .

RUN chown -R build:build /src/hashcat

USER build

RUN ["patch", "src/Makefile", "hashcat_shared.patch"]

CMD ["make", "DESTDIR=/out", "PREFIX=", "install"]
