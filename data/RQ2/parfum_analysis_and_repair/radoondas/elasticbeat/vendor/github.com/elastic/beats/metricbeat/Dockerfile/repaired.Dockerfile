FROM golang:1.6.2
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends -y netcat python-virtualenv python-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;


## Install go package dependencies
RUN set -x \
  go get \
	github.com/pierrre/gotestcover \
	github.com/tsg/goautotest \
	golang.org/x/tools/cmd/vet

# Setup work environment
ENV METRICBEAT_PATH /go/src/github.com/elastic/beats/metricbeat
ENV GO15VENDOREXPERIMENT=1

RUN mkdir -p $METRICBEAT_PATH/build/coverage
WORKDIR $METRICBEAT_PATH
