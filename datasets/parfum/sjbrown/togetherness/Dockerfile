FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    python-dev \
    vim \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /togetherness/src

COPY . /togetherness

CMD python2 -m SimpleHTTPServer 80

