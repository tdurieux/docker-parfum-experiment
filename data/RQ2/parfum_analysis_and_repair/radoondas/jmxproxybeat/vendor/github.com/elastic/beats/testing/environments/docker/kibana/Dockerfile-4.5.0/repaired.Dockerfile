FROM debian:jessie

# add our user and group first to make sure their IDs get assigned consistently
RUN groupadd -r kibana && useradd -r -m -g kibana kibana

RUN apt-get update && apt-get install -y ca-certificates curl --no-install-recommends && rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
RUN gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN arch="$(dpkg --print-architecture)" \
	&& set -x \
	&& curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch" \
	&& curl -f -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch.asc" \
	&& gpg --batch --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

ENV KIBANA_VERSION 4.4.0

RUN set -x \
 -f \
	&& curl -fSL "https://d \
	&& mkdir -p /opt/kibana \
	&& tar -xz --strip-components=1 -C /o \
	&& chown -R kibana:

ENV PATH /opt/kibana/bin:$PATH

COPY ./docker-entrypoint.sh /

RUN gosu kibana kibana plugin --install elastic/sense
RUN gosu kibana kibana plugin --install kibana/timelion

EXPOSE 5601
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kibana"]
