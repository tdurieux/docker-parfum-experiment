FROM ubuntu:20.04

LABEL maintainer="Pascal Watteel"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -y && apt upgrade -y && apt install --no-install-recommends openjdk-8-jre-headless wget -y && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /srv
VOLUME /srv
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 25565

ENTRYPOINT [ "/start.sh" ]