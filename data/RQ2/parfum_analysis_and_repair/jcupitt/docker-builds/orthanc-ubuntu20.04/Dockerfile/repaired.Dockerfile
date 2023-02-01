FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
	&& apt-get upgrade -y

RUN apt-get install --no-install-recommends -y \
	orthanc && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/orthanc-config

