FROM debian:stretch
MAINTAINER Jorge Figueiredo <jorgefigueiredo@outlook.com>

RUN apt-get update && apt-get install -y \
	traceroute \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "traceroute" ]