FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install --no-install-recommends -y alsa && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y alsa-utils mosquitto mosquitto-clients \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY voice2audio.sh /
CMD ./voice2audio.sh
