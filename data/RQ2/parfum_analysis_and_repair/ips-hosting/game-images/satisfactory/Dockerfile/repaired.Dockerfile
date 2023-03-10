FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive \
	&& groupadd -g 1000 ips-hosting \
	&& useradd -m -d /home/ips-hosting -u 1000 -g 1000 ips-hosting \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y lib32gcc1 wget tar tzdata libsdl2-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/* /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

COPY --chown=ips-hosting:ips-hosting --chmod=777 ./entrypoint.sh /ips-hosting/

USER ips-hosting
WORKDIR /home/ips-hosting
VOLUME /home/ips-hosting

EXPOSE 15777/udp
EXPOSE 15000/udp
EXPOSE 7777/udp

ENTRYPOINT ["/bin/bash", "/ips-hosting/entrypoint.sh"]
