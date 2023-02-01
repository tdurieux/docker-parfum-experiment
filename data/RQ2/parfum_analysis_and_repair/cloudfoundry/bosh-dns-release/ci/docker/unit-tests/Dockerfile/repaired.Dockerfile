FROM ubuntu:xenial

RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY --from=golang:1 /usr/local/go /usr/local/go
ENV GOROOT=/usr/local/go PATH=/usr/local/go/bin:$PATH
