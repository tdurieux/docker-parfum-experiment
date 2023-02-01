# Beats dockerfile used for testing
FROM golang:1.7.6
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends -y netcat python-virtualenv python-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PYTHON_ENV=/tmp/python-env

RUN test -d ${PYTHON_ENV} || virtualenv ${PYTHON_ENV}
RUN . ${PYTHON_ENV}/bin/activate && pip install --no-cache-dir nose jinja2 PyYAML nose-timer

# Packetbeat specifics
RUN apt-get install --no-install-recommends -y libpcap-dev geoip-database && apt-get clean && rm -rf /var/lib/apt/lists/*;

