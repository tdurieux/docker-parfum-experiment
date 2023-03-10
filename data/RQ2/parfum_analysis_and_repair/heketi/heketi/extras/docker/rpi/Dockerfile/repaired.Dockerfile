# set author and base
FROM resin/rpi-raspbian
MAINTAINER Luis Pabón <luis.pabon@coreos.com>

LABEL version="1.0.0"
LABEL description="Heketi Container for Raspberry Pi"

ADD ./heketi /usr/bin/heketi
ADD ./heketi-cli /usr/bin/heketi-cli
ADD ../../container/heketi.json /etc/heketi/heketi.json
ADD ../../conatiner/heketi-start.sh /usr/bin/heketi-start.sh
VOLUME /etc/heketi

VOLUME /var/lib/heketi

# expose port, set user and set entrypoint with config option