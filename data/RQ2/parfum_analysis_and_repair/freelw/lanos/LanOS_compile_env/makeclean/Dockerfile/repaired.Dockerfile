FROM ubuntu:18.04

RUN apt update \
	&& apt-get -y --no-install-recommends install nasm gcc make && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /root/entrypoint.sh
WORKDIR /root/
ENTRYPOINT ["/root/entrypoint.sh"]
