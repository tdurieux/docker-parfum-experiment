FROM debian:jessie

MAINTAINER will@zifferent.com
ENV project platform

RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-utils && \
    apt-get -y --no-install-recommends install build-essential && \
    apt-get -y --no-install-recommends install vim && \
    apt-get -y --no-install-recommends install git && \
    apt-get -y --no-install-recommends install mercurial && \
    apt-get -y --no-install-recommends install curl && \
    apt-get -y --no-install-recommends install zlib1g zlib1g-dev && \
    apt-get -y --no-install-recommends install libfreetype6-dev && \
    apt-get -y --no-install-recommends install python3 && \
    apt-get -y --no-install-recommends install python3-dev && rm -rf /var/lib/apt/lists/*;

ADD sources.list /etc/apt/

RUN apt-get update

RUN mknod /dev/fb0 c 29 0

ADD requirements.txt /${project}/

RUN \
    apt-get -y --no-install-recommends install python3-pip && \
    apt-get -y build-dep python-pygame && \
    cd /${project} && \
    pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install x11-apps && rm -rf /var/lib/apt/lists/*;

COPY . /${project}/

WORKDIR /${project}

