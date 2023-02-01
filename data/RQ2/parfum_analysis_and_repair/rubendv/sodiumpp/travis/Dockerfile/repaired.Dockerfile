FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install g++ clang cmake wget libsodium-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/sodiumpp
WORKDIR /opt/sodiumpp
