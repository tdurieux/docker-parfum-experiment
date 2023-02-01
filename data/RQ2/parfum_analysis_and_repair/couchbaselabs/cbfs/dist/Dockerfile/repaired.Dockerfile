FROM ubuntu:14.04

MAINTAINER Traun Leyden <tleyden@couchbase.com>

ENV GOPATH /opt/go
ENV PATH $GOPATH/bin:$PATH

ADD refresh-cbfs /usr/local/bin/

# Get dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  golang \
  mercurial && rm -rf /var/lib/apt/lists/*;

# Install cbfs + client
RUN refresh-cbfs


