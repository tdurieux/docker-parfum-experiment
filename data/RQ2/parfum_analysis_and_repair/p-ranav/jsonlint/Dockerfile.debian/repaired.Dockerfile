ARG BASE_IMAGE=debian:sid-slim

FROM ${BASE_IMAGE} AS builder

RUN apt-get update \
    && apt-get install  -y --no-install-recommends ca-certificates git cmake make clang && rm -rf /var/lib/apt/lists/*;

WORKDIR /build

RUN git clone https://github.com/p-ranav/jsonlint.git

WORKDIR /build/jsonlint/build

RUN git rev-parse > git-revision

RUN cmake .. \ 
    && make \
    && make check

FROM ${BASE_IMAGE}

WORKDIR /jsonlint

COPY --from=builder /build/jsonlint/build/git-revision .
COPY --from=builder /build/jsonlint/build/jsonlint .
