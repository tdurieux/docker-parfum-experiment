FROM phusion/baseimage:0.10.0
LABEL maintainer "Nazar Mokrynskyi <nazar@mokrynskyi.com>"

COPY webserver-common /webserver-common/

RUN \

	/webserver-common/create-git-user.sh && \

	/webserver-common/apt-get-update.sh && \
	/webserver-common/apt-get-install-common.sh && \
	/webserver-common/apt-get-install-ceph-fuse.sh && \

	apt-get install -y --no-install-recommends git mc wget \
		php-cli \
		php-curl \
		php-bcmath \
		php-bz2 \
		php-exif \
		php-ftp \
		php-gd \
		php-gettext \
		php-mbstring \
		php-mcrypt \
		php-mysqli \
		php-opcache \
		php-shmop \
		php-sockets \
		php-sysvmsg \
		php-sysvsem \
		php-sysvshm \
		php-zip && \

	/webserver-common/apt-get-cleanup.sh && \

# Enable SSH
 -f

COPY ssh/webserver-entrypoint.sh /

ENV \
	CEPH_MON_SERVICE=ceph-mon \
	CEPHFS_MOUNT=0 \

	TERM=xterm

VOLUME \
	/data \
	/etc/ssh

ENTRYPOINT ["/webserver-entrypoint.sh"]
