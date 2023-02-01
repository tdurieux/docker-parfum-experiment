FROM ubuntu:bionic

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  unzip ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD assets/ /opt/resource/
