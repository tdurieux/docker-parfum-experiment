FROM ubuntu:16.04

RUN apt update && apt-get install --no-install-recommends -y make g++ && rm -rf /var/lib/apt/lists/*;

WORKDIR /cpp
