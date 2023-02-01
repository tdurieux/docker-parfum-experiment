#----------------------------------------------------------------------------------------------
FROM redis:bullseye AS redis
FROM debian:bullseye-slim AS builder

SHELL ["/bin/bash", "-l", "-c"]

WORKDIR /build
COPY --from=redis /usr/local/ /usr/local/

ADD . /build

RUN ./deps/readies/bin/getupdates
RUN ./deps/readies/bin/getpy3
RUN ./system-setup.py
RUN make fetch build

#----------------------------------------------------------------------------------------------