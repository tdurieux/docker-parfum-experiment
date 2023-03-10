FROM ubuntu:xenial-20170802

LABEL maintainer=""

ENV DEBIAN_FRONTEND=noninteractive

COPY apt-conf /etc/apt/apt.conf.d/

RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf \
                    python3-dev \
                    python-dev \
                    libiberty-dev \
                    build-essential \
                    make && rm -rf /var/lib/apt/lists/*;
