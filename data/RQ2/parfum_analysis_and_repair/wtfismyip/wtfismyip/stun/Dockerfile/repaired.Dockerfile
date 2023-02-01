FROM debian:unstable

MAINTAINER Clint Ruoho clint@wtfismyip.com

RUN apt-get -y update && apt-get -y --no-install-recommends install coturn procps && rm -rf /var/lib/apt/lists/*;

COPY turnserver.conf /etc/turnserver.conf

CMD [ "/usr/bin/turnserver" ]
