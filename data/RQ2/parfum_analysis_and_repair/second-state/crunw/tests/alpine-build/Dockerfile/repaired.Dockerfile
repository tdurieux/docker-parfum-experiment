FROM alpine

RUN apk add --no-cache gcc automake autoconf libtool gettext pkgconf git make musl-dev \
    python3 libcap-dev libseccomp-dev yajl-dev argp-standalone go-md2man

COPY run-tests.sh /usr/local/bin

ENTRYPOINT /usr/local/bin/run-tests.sh
