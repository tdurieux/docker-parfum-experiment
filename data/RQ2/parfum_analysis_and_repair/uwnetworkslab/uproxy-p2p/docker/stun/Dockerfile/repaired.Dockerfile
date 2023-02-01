FROM ubuntu:trusty
MAINTAINER Trevor Johnston <trevj@google.com>

RUN apt-get update -qq && apt-get install --no-install-recommends -y rfc5766-turn-server && rm -rf /var/lib/apt/lists/*;

RUN echo 'stun-only' >> /etc/turnserver.conf
RUN echo 'TURNSERVER_ENABLED=1' >> /etc/default/rfc5766-turn-server

EXPOSE 3478/udp
CMD /usr/bin/turnserver
