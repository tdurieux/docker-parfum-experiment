FROM ubuntu:16.04

Maintainer Itamar Lavender <itamar.lavender@gmail.com>

ENV LANG C.UTF-8
ENV PYCURL_SSL_LIBRARY nss
ENV PROJECT_DIR /usr/local/sensudrive


RUN apt-get update && apt-get install --no-install-recommends -y \
  vim \
  lsb-release \
  python3.5 \
  python3-pip \
  python3-dev \
  libpq-dev \
  gcc && rm -rf /var/lib/apt/lists/*;


ADD . ${PROJECT_DIR}/

RUN pip3 install --no-cache-dir --upgrade pip && \
	pip3 install --no-cache-dir -q --upgrade --exists-action=w -r ${PROJECT_DIR}/requirements.txt

WORKDIR ${PROJECT_DIR}
