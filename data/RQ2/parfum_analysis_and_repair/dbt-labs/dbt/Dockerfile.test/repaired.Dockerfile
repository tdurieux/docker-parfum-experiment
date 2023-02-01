##
#  This dockerfile is used for local development and adapter testing only.
#  See `/docker` for a generic and production-ready docker file
##

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository ppa:git-core/ppa -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    netcat \
    postgresql \
    curl \
    git \
    ssh \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
    libsasl2-dev \
    libsasl2-2 \
    libsasl2-modules-gssapi-mit \
    libyaml-dev \
    unixodbc-dev \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install --no-install-recommends -y \
    python \
    python-dev \
    python3-pip \
    python3.6 \
    python3.6-dev \
    python3-pip \
    python3.6-venv \
    python3.7 \
    python3.7-dev \
    python3.7-venv \
    python3.8 \
    python3.8-dev \
    python3.8-venv \
    python3.9 \
    python3.9-dev \
    python3.9-venv \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG DOCKERIZE_VERSION=v0.6.1
RUN curl -f -LO https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN pip3 install --no-cache-dir -U tox wheel six setuptools

# These args are passed in via docker-compose, which reads then from the .env file.
# On Linux, run `make .env` to create the .env file for the current user.
# On MacOS and Windows, these can stay unset.
ARG USER_ID
ARG GROUP_ID

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    groupadd -g ${GROUP_ID} dbt_test_user && \
    useradd -m -l -u ${USER_ID} -g ${GROUP_ID} dbt_test_user; \
    else \
    useradd -mU -l dbt_test_user; \
    fi
RUN mkdir /usr/app && chown dbt_test_user /usr/app
RUN mkdir /home/tox && chown dbt_test_user /home/tox

WORKDIR /usr/app
VOLUME /usr/app

USER dbt_test_user

ENV PYTHONIOENCODING=utf-8
ENV LANG C.UTF-8
