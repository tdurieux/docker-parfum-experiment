FROM ubuntu:16.04

MAINTAINER Tudor Golubenco <tudor@elastic.co>

# install fpm
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential ruby-dev rpm zip dos2unix libgmp3-dev && rm -rf /var/lib/apt/lists/*;

RUN gem install fpm
