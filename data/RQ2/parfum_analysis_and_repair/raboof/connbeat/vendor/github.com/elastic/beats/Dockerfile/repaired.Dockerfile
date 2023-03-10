FROM golang:1.7.6
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends -y netcat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY libbeat/scripts/docker-entrypoint.sh /entrypoint.sh

RUN mkdir -p /etc/pki/tls/certs
COPY testing/environments/docker/logstash/pki/tls/certs/logstash.crt /etc/pki/tls/certs/logstash.crt

# Create a copy of the repository inside the container.
COPY . /go/src/github.com/elastic/beats/
