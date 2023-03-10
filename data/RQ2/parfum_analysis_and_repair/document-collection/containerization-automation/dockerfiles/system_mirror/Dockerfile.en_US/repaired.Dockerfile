# $ docker build -t zjzstu/ubuntu:18.04 -t zjzstu/ubuntu:latest .
# $ docker run -it --rm zjzstu/ubuntu bash

FROM ubuntu:18.04
LABEL maintainer "zhujian <zjzstu@github.com>"

COPY sources.list .
ENV DEBIAN_FRONTEND=noninteractive
RUN mv sources.list /etc/apt/sources.list && \
	apt-get update && \
	apt-get install --no-install-recommends -y locales tzdata && \
	locale-gen en_US.UTF-8 && \
	update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
	ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete && rm -rf /var/lib/apt/lists/*;

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8