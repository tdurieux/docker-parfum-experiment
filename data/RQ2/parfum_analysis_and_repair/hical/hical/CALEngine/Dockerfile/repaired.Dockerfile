FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    libfcgi-dev spawn-fcgi g++ libarchive-dev make git && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /src/
