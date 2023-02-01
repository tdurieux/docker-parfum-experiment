FROM debian:wheezy
MAINTAINER OLX Team

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y curl lsb-release locales && rm -rf /var/lib/apt/lists/*;
