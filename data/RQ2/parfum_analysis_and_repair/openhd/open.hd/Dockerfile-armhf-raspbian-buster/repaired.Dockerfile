FROM ghcr.io/openhd/2020-05-27-raspios-buster-lite-armhf

RUN apt update --allow-releaseinfo-change

COPY install_dep.sh /data/install_dep.sh

RUN /data/install_dep.sh

COPY . /data/

WORKDIR /data

ARG CLOUDSMITH_API_KEY=000000000000

RUN export CLOUDSMITH_API_KEY=$CLOUDSMITH_API_KEY

RUN /data/package.sh armhf raspbian buster docker