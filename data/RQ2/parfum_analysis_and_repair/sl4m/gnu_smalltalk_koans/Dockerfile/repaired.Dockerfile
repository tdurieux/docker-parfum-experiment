FROM debian:stretch-slim
MAINTAINER skim <skimla@gmail.com>

ENV HOME /root

RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y gnu-smalltalk && rm -rf /var/lib/apt/lists/*;

WORKDIR /koans
