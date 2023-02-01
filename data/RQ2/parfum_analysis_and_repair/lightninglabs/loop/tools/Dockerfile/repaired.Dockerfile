FROM golang:1.18.0-buster

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
ENV GOCACHE=/tmp/build/.cache
ENV GOMODCACHE=/tmp/build/.modcache

COPY . /tmp/tools

RUN cd /tmp \
  && mkdir -p /tmp/build/.cache \
  && mkdir -p /tmp/build/.modcache \
  && cd /tmp/tools \
  && go install -trimpath -tags=tools github.com/golangci/golangci-lint/cmd/golangci-lint \
  && chmod -R 777 /tmp/build/

WORKDIR /build