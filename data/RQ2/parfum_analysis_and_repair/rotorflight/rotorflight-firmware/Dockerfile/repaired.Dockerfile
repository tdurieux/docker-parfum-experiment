FROM ubuntu:bionic

RUN apt-get -y update && apt-get -y --no-install-recommends install \
    build-essential \
    python \
    curl \
    git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade






RUN mkdir /rotorflight
WORKDIR /rotorflight
