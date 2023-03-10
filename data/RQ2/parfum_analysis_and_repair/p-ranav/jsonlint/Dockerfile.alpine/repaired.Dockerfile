ARG BASE_IMAGE=alpine:latest

FROM ${BASE_IMAGE} AS builder

RUN apk update \
    && apk add --no-cache git cmake make binutils musl-dev g++

WORKDIR /build

RUN git clone https://github.com/p-ranav/jsonlint.git

WORKDIR /build/jsonlint/build

RUN git rev-parse > git-revision

RUN cmake .. \ 
    && make \
    && make check

FROM ${BASE_IMAGE}

RUN apk update \
    && apk add --no-cache libgcc libstdc++

WORKDIR /jsonlint

COPY --from=builder /build/jsonlint/build/git-revision .
COPY --from=builder /build/jsonlint/build/jsonlint .
