# Implements wire functionality

FROM debian:wheezy
MAINTAINER Richard Cziva, Simon Jouet, Kyle White

RUN apt-get update && apt-get install --no-install-recommends -y \
	bridge-utils \
	net-tools \
	iptables && rm -rf /var/lib/apt/lists/*;

ADD ifinit /usr/local/bin/
ADD brinit /usr/local/bin/
RUN chmod +x /usr/local/bin/ifinit
RUN chmod +x /usr/local/bin/brinit
ENTRYPOINT ifinit && /bin/bash
