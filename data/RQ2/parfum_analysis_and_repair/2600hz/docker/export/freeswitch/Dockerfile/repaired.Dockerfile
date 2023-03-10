#FROM debian:jessie
FROM tklx/base:0.1.1
MAINTAINER Roman Galeev <jamhed@2600hz.com>

# override this (if needed) with run --env option
ENV NETWORK=kazoo
ENV RTP_START_PORT=10000

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

COPY etc/deps /root/deps
COPY etc/sources.list /etc/apt/sources.list
COPY etc/freeswitch.key.gpg /root/freeswitch.key.gpg
ADD freeswitch.tar /usr/local/
RUN groupadd freeswitch \
	&& useradd --home-dir /usr/local/freeswitch -g freeswitch freeswitch \
	&& cat /root/freeswitch.key.gpg | apt-key add - \
	&& apt-get -y update \
	&& apt-get -y --no-install-recommends install erlang-base wget curl xmlstarlet $(cat /root/deps) \
	&& apt-get -y clean \
	&& apt-clean --aggressive && rm -rf /var/lib/apt/lists/*;

USER freeswitch
WORKDIR "/usr/local/freeswitch"
ENTRYPOINT [ "./run-deploy.sh" ]
