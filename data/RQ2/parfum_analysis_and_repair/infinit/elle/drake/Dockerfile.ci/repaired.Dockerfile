FROM ubuntu:16.04 AS trusty-ci

RUN apt-get update && apt-get install --no-install-recommends -y curl git python3.5 python3-pip && rm -rf /var/lib/apt/lists/*
RUN curl -f https://download.docker.com/linux/static/stable/x86_64/docker-19.03.1.tgz | tar -C /usr/bin -xz docker/docker --strip-components 1

FROM trusty-ci AS trusty-check

ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
