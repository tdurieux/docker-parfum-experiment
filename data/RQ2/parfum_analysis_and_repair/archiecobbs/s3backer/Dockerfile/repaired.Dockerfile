FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  autoconf \
  libcurl4-openssl-dev \
  libfuse-dev \
  libexpat1-dev && rm -rf /var/lib/apt/lists/*;

ADD . s3backer

WORKDIR "./s3backer"

RUN ["./autogen.sh"]
RUN ["./configure"]
RUN ["make"]
RUN ["make", "install"]
