FROM golang:1.9.4
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         netcat python-pip virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade setuptools

# Setup work environment
ENV FILEBEAT_PATH /go/src/github.com/elastic/beats/filebeat

RUN mkdir -p $FILEBEAT_PATH/build/coverage
WORKDIR $FILEBEAT_PATH
