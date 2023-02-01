FROM ghcr.io/openhd/2020-05-27-raspios-buster-lite-armhf

COPY .git /data/.git/

COPY . /data/

RUN apt-get update --allow-releaseinfo-change

WORKDIR /data

ARG CLOUDSMITH_API_KEY=000000000000

RUN export CLOUDSMITH_API_KEY=$CLOUDSMITH_API_KEY

RUN /data/package.sh armhf raspbian buster docker