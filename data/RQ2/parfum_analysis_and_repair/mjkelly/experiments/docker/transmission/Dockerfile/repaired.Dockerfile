FROM ubuntu:latest
MAINTAINER Michael Kelly <m@michaelkelly.org>

RUN apt-get update && apt-get install --no-install-recommends -y supervisor transmission-daemon && rm -rf /var/lib/apt/lists/*;

COPY ./supervisord.conf /etc/supervisord.conf

VOLUME /transmission/data
VOLUME /transmission/config

EXPOSE 49164 9091
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
