FROM golang:1.17.11
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         netcat python3 python3-pip python3-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PYTHON_ENV=/tmp/python-env

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools

# Setup work environment
ENV APM_SERVER_PATH /go/src/github.com/elastic/apm-server

RUN mkdir -p $APM_SERVER_PATH
WORKDIR $APM_SERVER_PATH

COPY . $APM_SERVER_PATH

RUN make

CMD ./apm-server -e -d "*"

# Add healthcheck for docker/healthcheck metricset to check during testing
HEALTHCHECK CMD exit 0
