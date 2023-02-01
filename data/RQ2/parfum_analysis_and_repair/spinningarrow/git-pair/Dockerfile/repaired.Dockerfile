FROM alpine:latest

RUN apk update
RUN apk add --no-cache bash

# Runtime dependencies
RUN apk add --no-cache coreutils
RUN apk add --no-cache git
RUN apk add --no-cache util-linux# for column

# Test dependencies
RUN apk add --no-cache bats
RUN apk add --no-cache expect
RUN apk add --no-cache ncurses# for tput

COPY git-pair /usr/local/bin/

ENTRYPOINT ["/tests/test.bats"]
