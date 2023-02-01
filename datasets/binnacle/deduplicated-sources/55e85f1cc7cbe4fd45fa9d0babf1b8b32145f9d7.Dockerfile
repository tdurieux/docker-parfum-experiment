FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONUNBUFFERED 1

RUN apt-get update -qq

# For python 3.6
RUN apt-get install -yqq software-properties-common \
  && add-apt-repository ppa:jonathonf/python-3.6 \
  && apt-get update -qq

RUN apt-get update \
  && apt-get install -y postgresql-client \
    libproj-dev \
    gdal-bin \
    memcached \
    libmemcached-dev \
    build-essential \
    python3.6 \
    python3-pip \
    python-virtualenv \
    python3.6-dev \
    git \
    libssl-dev \
    libpq-dev \
    gfortran \
    libatlas-base-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev \
    python-software-properties \
    ghostscript \
    python3-celery \
    python3-sphinx \
    openjdk-9-jre-headless \
    locales \
    pkg-config \
    gcc \
    libtool \
    automake

RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
RUN dpkg-reconfigure locales

RUN useradd -m onadata
RUN mkdir -p /srv/onadata && chown -R onadata:onadata /srv/onadata
USER onadata
RUN mkdir -p /srv/onadata/requirements

ADD requirements /srv/onadata/requirements/

WORKDIR /srv/onadata

ADD . /srv/onadata/

ENV DJANGO_SETTINGS_MODULE onadata.settings.docker

USER root

# for local development tmux is a nice to have
RUN apt-get install -y tmux

RUN rm -rf /var/lib/apt/lists/* \
  && find . -name '*.pyc' -type f -delete

USER onadata

# Run tmux to use bash shell.
RUN echo "set-option -g default-shell /bin/bash" > ~/.tmux.conf

CMD ["/srv/onadata/docker/docker-entrypoint.sh"]
