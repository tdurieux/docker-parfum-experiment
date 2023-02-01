# $BOONTADATA_DOCKER_REGISTRY/boontadata/pyclientbase
#
# VERSION   0.1

FROM continuumio/anaconda3

MAINTAINER boontadata <contact@boontadata.io>

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		git \
		build-essential \
		vim \
		telnet && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir kafka-python && \
	pip install --no-cache-dir cassandra-driver

ENTRYPOINT ["init"]
