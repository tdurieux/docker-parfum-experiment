FROM ghcr.io/openhd/armbian_20.08_buster_arm64

COPY .git /data/.git/

COPY . /data/

RUN apt-get update --allow-releaseinfo-change

WORKDIR /data

ARG CLOUDSMITH_API_KEY=000000000000

RUN export CLOUDSMITH_API_KEY=$CLOUDSMITH_API_KEY

RUN /data/package.sh arm64 debian buster docker