FROM debian:bullseye
MAINTAINER Tobias Junghans <tobydox@veyon.io>

RUN \
	apt-get update && \
	apt-get install --no-install-recommends -y \
		flawfinder \
		&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
