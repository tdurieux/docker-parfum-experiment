FROM ubuntu
# based off of https://github.com/themattrix/docker-tox/blob/79105882a37762972c0d1147ea09fba0d2e6f26e/Dockerfile

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
       git \
       libmysqlclient-dev \
       libpq-dev \
       mysql-server \
       postgresql \
       python-pip \
       python-software-properties \
       software-properties-common \
       wget \
    && add-apt-repository -y ppa:fkrull/deadsnakes \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
       python2.6-dev \
       python2.7-dev \
       python3.2-dev \
       python3.3-dev \
       python3.4-dev \
       python3.5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir tox

WORKDIR /app/
ADD . /app/

CMD tox
