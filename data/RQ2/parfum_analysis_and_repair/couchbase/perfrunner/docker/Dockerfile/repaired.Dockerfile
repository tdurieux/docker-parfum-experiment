FROM ubuntu:16.04

MAINTAINER Pavel Paulau <pavel@couchbase.com>

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y build-essential git libcurl4-gnutls-dev libffi-dev libsnappy-dev libssl-dev lsb-core python3-dev python-pip python-virtualenv wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-4-amd64.deb
RUN dpkg -i couchbase-release-1.0-4-amd64.deb
RUN apt update && apt install --no-install-recommends -y libcouchbase-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt
RUN git clone https://github.com/couchbase/perfrunner.git

WORKDIR /opt/perfrunner
RUN make
