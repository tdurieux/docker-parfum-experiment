FROM ubuntu:14.04
MAINTAINER as <as@docker.com>

RUN apt-get update && apt-get -y --no-install-recommends install expect openssh-server openssh-client nano vim cmake apt-transport-https software-properties-common git libboost1.54-all-dev && rm -rf /var/lib/apt/lists/*;
RUN yes | apt-get upgrade


# RUN apt-get install libssl-dev libcurl4-openssl-dev libssl-dev libproj-dev libgdal-dev nano

RUN useradd --home /home/scidb --create-home --uid 1005 --group sudo --shell /bin/bash scidb

RUN echo 'root:666.666.666.666' | chpasswd
RUN echo 'scidb:666.666.666.666' | chpasswd

