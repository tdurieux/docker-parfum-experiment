FROM debian:latest

LABEL maintainer Federico Pereira <fpereira@cnsoluciones.com>

RUN apt-get -q update \
	&& DEBIAN_FRONTEND=noninteractive \
	&& apt-get install --no-install-recommends -y wine64 \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*;

volume /root/.wine

COPY winbox64.exe /opt/winbox.exe
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /opt/winbox.exe /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
