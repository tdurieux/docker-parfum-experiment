FROM debian:latest
MAINTAINER Adam Schwalm <adamschwalm@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y make gcc file g++ patch wget cpio python unzip rsync bc bzip2 git && rm -rf /var/lib/apt/lists/*; # install dependencies

