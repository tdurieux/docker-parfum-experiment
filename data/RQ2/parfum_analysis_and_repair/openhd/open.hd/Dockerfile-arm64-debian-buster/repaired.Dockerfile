FROM ghcr.io/openhd/armbian_20.08_buster_arm64:latest

RUN apt update --allow-releaseinfo-change

COPY install_dep.sh /data/install_dep.sh

RUN /data/install_dep.sh

COPY . /data/

WORKDIR /data

ARG CLOUDSMITH_API_KEY=000000000000

RUN export CLOUDSMITH_API_KEY=$CLOUDSMITH_API_KEY

RUN /data/package.sh arm64 debian buster docker