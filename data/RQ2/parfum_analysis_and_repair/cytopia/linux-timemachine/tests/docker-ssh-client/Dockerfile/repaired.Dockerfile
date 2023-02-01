FROM debian:buster-slim


###
### Install SSH Server
###
RUN set -eux \
	&& apt update \
	&& apt install --no-install-recommends -y \
		rsync \
		openssh-client && rm -rf /var/lib/apt/lists/*;

###
### Configure SSH
###
RUN set -eux \
	&& mkdir -p /root/.ssh \
	&& chmod 0700 /root/.ssh

###
### Add private key
###
COPY id_rsa /root/.ssh/id_rsa

RUN set -eux \
	&& chmod 0400 /root/.ssh/id_rsa

###
### Add backup directories
###
RUN set -eux \
	&& mkdir -p /root/backup1 \
	&& mkdir -p /backup2

COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
