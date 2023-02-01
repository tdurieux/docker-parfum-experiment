# Change to debian:9 or debian:sid for other Debian releases
FROM debian:8

RUN mkdir /nscp
ADD . /nscp/

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y cmake python python-dev libssl-dev libboost-all-dev protobuf-compiler python-protobuf libprotobuf-dev python-sphinx libcrypto++-dev libcrypto++ liblua5.1-0-dev libgtest-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git wget dos2unix debhelper dh-virtualenv python-pip zip devscripts && rm -rf /var/lib/apt/lists/*;

ENV GH_TOKEN=UPDATE_ME

RUN chmod u+x /nscp/ext/md-protobuf/protoc-gen-md

RUN pip install --no-cache-dir jinja2 mkdocs mkdocs-material github3.py

RUN mkdir -p /build
RUN mkdir -p /packages

VOLUME /packages

WORKDIR /build

CMD /nscp/build/sh/build-debian.sh

