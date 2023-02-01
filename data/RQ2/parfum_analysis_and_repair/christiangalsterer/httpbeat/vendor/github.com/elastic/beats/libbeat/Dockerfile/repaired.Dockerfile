# Beats dockerfile used for testing
FROM golang:1.7.6
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         netcat python-pip virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PYTHON_ENV=/tmp/python-env

RUN test -d ${PYTHON_ENV} || virtualenv ${PYTHON_ENV}
COPY ./tests/system/requirements.txt /tmp/requirements.txt

# Upgrade pip to make sure to have the most recent version
RUN . ${PYTHON_ENV}/bin/activate && pip install --no-cache-dir -U pip
RUN . ${PYTHON_ENV}/bin/activate && pip install --no-cache-dir -Ur /tmp/requirements.txt

# Libbeat specific
RUN mkdir -p /etc/pki/tls/certs
