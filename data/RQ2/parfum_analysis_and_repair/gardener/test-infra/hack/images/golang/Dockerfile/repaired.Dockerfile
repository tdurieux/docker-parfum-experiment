FROM golang:1.14.1 AS ginkgo

RUN \
  apt-get update \
  && apt-get install --no-install-recommends rsync -y \
  && go get -u github.com/onsi/ginkgo/ginkgo && rm -rf /var/lib/apt/lists/*;

COPY ./setup /tm/setup