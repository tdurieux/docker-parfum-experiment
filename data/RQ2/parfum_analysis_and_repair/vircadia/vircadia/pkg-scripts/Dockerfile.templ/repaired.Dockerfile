FROM ubuntu:18.04
ARG DEPENDS
ARG GITSRC
ARG GITDATE
ARG GITCOMMIT

# starting out as root, will drop back in entrypoint.sh
USER root

# expose ports for domain server
EXPOSE 40100 40101 40102
EXPOSE 40100/udp 40101/udp 40102/udp

# expose ports for assignment client
EXPOSE 48000/udp 48001/udp 48002/udp 48003/udp 48004/udp 48005/udp 48006/udp

RUN echo UTC >/etc/timezone
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	apt-get install --no-install-recommends -y tzdata supervisor ${DEPENDS} && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	mkdir -p /var/lib/vircadia
RUN groupadd -r vircadia ; \
	useradd -Nr vircadia -d /var/lib/vircadia ; \
	usermod -aG vircadia vircadia ; \
	chown vircadia.vircadia /var/lib/vircadia ; \
	exit 0

VOLUME /var/lib/vircadia

RUN mkdir -p /var/run ; chmod 777 /var/run
COPY vircadia.conf /etc/supervisor/conf.d/vircadia.conf

COPY entrypoint.sh /
COPY opt /opt/vircadia
COPY lib /opt/vircadia/lib

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/vircadia.conf"]
LABEL \
	net.vircadia.gitsrc="${GITSRC}" \
	net.vircadia.gitdate="${GITDATE}" \
	net.vircadia.gitcommit="${GITCOMMIT}"
