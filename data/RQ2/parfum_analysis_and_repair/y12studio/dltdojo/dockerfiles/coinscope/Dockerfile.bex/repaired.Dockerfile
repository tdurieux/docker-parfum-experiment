FROM y12docker/dltdojo-bex
# https://github.com/jameslitton/coinscope
RUN apk --update --no-cache add --virtual .builddeps build-base python linux-headers musl-dev && \
    git clone --depth=1 https://github.com/jameslitton/coinscope.git /coinscope
#    apk --no-cache --purge del .builddeps
#    rm -rf /tmp/*
RUN apk add --no-cache perl libconfig-dev libev-dev boost-dev
RUN apk add --no-cache openssl-dev
WORKDIR /coinscope
RUN make
#
# src/console_from_file.cpp:23:14: error: expected unqualified-id before numeric constant
# const size_t PAGE_SIZE = 4096;
#
