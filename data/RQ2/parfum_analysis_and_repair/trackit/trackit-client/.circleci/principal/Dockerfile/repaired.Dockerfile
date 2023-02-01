FROM circleci/node:7.10
MAINTAINER Victor Schubert <victor@trackit.io>

RUN \
	sudo apt-get update \
	&& sudo apt-get -y upgrade \
	&& sudo apt-get -y --no-install-recommends install awscli \
	&& sudo rm -rf /var/lib/apt/lists/*
