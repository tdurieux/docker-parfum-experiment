FROM docker.elastic.co/kibana/kibana:5.6.3

WORKDIR /

USER root

ENV GOSU_VERSION 1.10
RUN set -ex; \

	yum -y install epel-release; rm -rf /var/cache/yum \
	yum -y install wget dpkg; \

	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \

# verify the signature
	export GNUPGHOME="$(mktemp -d)"; rm -rf -d \
	gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /tmp/gosu.asc /usr/bin/gosu; \
	rm -r "$GNUPGHOME" /tmp/gosu.asc; \

	chmod +x /usr/bin/gosu; \
# verify that the binary works
	gosu nobody true; \

	yum -y remove wget dpkg; \
	yum clean all

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kibana"]
