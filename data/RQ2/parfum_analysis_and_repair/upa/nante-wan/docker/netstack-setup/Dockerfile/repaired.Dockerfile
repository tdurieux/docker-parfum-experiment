FROM ubuntu:17.04

ARG workdir="/root"

RUN apt-get update && apt-get install --no-install-recommends -y \
	python3 iproute2 iptables kmod && rm -rf /var/lib/apt/lists/*;

ADD start.py ${workdir}/start.py

CMD [ "python3", "/root/start.py", "--network-only", "/etc/nante-wan.conf" ]
