FROM ubuntu:20.04
LABEL maintainer="HARUYAMA Seigo <haruyama@tankyu.net>"

WORKDIR /usr/local/bin
RUN apt update \
    && apt install -y tini \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

COPY release/hisui /usr/local/bin
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/hisui"]
