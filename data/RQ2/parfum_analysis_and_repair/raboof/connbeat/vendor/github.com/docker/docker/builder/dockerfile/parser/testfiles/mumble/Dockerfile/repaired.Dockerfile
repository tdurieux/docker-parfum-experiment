FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends libcap2-bin mumble-server -y && rm -rf /var/lib/apt/lists/*;

ADD ./mumble-server.ini /etc/mumble-server.ini

CMD /usr/sbin/murmurd
