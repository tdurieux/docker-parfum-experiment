FROM ubuntu:18.04
MAINTAINER Shadi Akiki

# pre-requisites
# https://github.com/kstaken/dockerfile-examples/blob/master/apache-php/Dockerfile
#
# add openssh-client is for ssh keys, for using with pip install of private repo on gitlab
# Note "redis" gets both server and cli
# Update 2020-01-02: Removing "apt-get install redis" in favor or using a separate container
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip git jq time && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install pew
RUN python3 -m pew new isitfit

# copy dependencies here to save on install step below and benefit from docker cache
RUN python3 -m pew in isitfit \
  pip install \
    Click==7.0 \
    pandas==0.25.1 \
    requests==2.22.0 \
    cachecontrol==0.12.5 \
    lockfile==0.12.2 \
    tabulate==0.8.3 \
    termcolor==1.1.0 \
    tqdm==4.32.2 \
    redis==3.3.8 \
    pyarrow==0.15.0 \
    awscli==1.16.248 \
    boto3==1.9.238 \
    datadog==0.30.0 \
    schema==0.7.1 \
    visidata==1.5.2 \
    outdated==0.2.0

# for unit tests
RUN python3 -m pew in isitfit pip install pytest

# install moto for testing purposes
# https://github.com/spulec/moto#stand-alone-server-mode
# 2019-07-23 not used ATM in the docker file
# RUN python3 -m pew in isitfit pip install moto[server]

# install isitfit package itself
WORKDIR /code
COPY . .
RUN chmod +x /code/docker-entrypoint.sh

# https://github.com/antirez/redis/issues/5055#issuecomment-405516849
# RUN sed -i "s/bind .*/bind 127.0.0.1/g" /etc/redis/redis.conf

RUN python3 -m pew in isitfit pip3 install .

# Some locale issues for click within docker
# https://click.palletsprojects.com/en/7.x/python3/#python-3-surrogate-handling
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# change workdir to a new workspace folder
WORKDIR /workspace

# Note: If CMD is used to provide default arguments for the ENTRYPOINT instruction,
# both the CMD and ENTRYPOINT instructions should be specified with the JSON array format.
# Copied from https://docs.docker.com/engine/reference/builder/
# ENTRYPOINT ["python3", "-m", "pew", "in", "isitfit"]
ENTRYPOINT ["/code/docker-entrypoint.sh"]
