FROM golang:1.12.4
MAINTAINER Pier-Hugues Pellerin <ph@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         netcat python-pip rsync virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade setuptools

# Setup work environment
ENV FUNCTIONBEAT_PATH /go/src/github.com/elastic/beats/x-pack/functionbeat

RUN mkdir -p $FUNCTIONBEAT_PATH/build/coverage
WORKDIR $FUNCTIONBEAT_PATH
