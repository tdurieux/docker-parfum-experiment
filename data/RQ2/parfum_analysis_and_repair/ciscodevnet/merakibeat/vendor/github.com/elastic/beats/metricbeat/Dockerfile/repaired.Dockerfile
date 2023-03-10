FROM golang:1.9.4
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         netcat python-pip virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade setuptools

# Setup work environment
ENV METRICBEAT_PATH /go/src/github.com/elastic/beats/metricbeat

RUN mkdir -p $METRICBEAT_PATH/build/coverage
WORKDIR $METRICBEAT_PATH

# Add healthcheck for docker/healthcheck metricset to check during testing
HEALTHCHECK CMD exit 0
