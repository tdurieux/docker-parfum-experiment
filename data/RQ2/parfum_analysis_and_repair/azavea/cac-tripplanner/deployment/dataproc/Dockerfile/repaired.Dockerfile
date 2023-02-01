FROM ubuntu:20.04

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src

RUN apt update && apt install --no-install-recommends -y curl osmctools && rm -rf /var/lib/apt/lists/*;

COPY . /usr/local/src
