FROM ubuntu:16.04
MAINTAINER Max Goltzsche <max.goltzsche@gmail.com>

RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y software-properties-common \
	&& add-apt-repository ppa:longsleep/golang-backports \
	&& apt-get update && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y golang-go libseccomp-dev libgpgme11-dev libassuan-dev btrfs-tools libdevmapper-dev curl && rm -rf /var/lib/apt/lists/*;
