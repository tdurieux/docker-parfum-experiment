FROM debian:stretch-slim as tini
ENV TINI_VERSION v0.18.0

RUN apt-get update && apt-get install -y --no-install-recommends \
      wget \
      ca-certificates \
      gnupg \
      dirmngr \
      apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/build && \
	cd /tmp/build && \
	wget -O tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static${TINI_ARCH} && \
	wget -O tini.asc https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static${TINI_ARCH}.asc && \
  gpg --batch --keyserver  keyserver.ubuntu.com --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
  gpg --batch --verify tini.asc tini && \
	cp tini /sbin/ && \
	chmod +x /sbin/tini && \
	cd /tmp && \
	rm -rf /tmp/build && \
	rm -rf /root/.gnupg

FROM openjdk:8-slim-stretch
LABEL maintainer="Ryan Schlesinger <ryan@ryanschlesinger.com>"

COPY --from=tini /sbin/tini /sbin/tini

RUN apt-get update && apt-get install -y --no-install-recommends \
      wget \
      ca-certificates \
      gnupg \
      dirmngr \
      apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Install any version from deb download
# Use dpkg to mark the package for install (expect it to fail to complete the installation)
# Use apt-get install -f to complete the installation with dependencies
ENV UNIFI_VERSION 7.0.23-5eeb859f85
ENV UNIFI_DOCKER_VERSION 7.0.23
RUN mkdir -p /usr/share/man/man1 && \
      mkdir -p /tmp/build && \
      cd /tmp/build && \
      wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg && \
      wget https://www.ubnt.com/downloads/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb && \
      apt-get update && apt-get install -y --no-install-recommends \
        ./unifi_sysvinit_all.deb \
        procps && \
      rm -rf /var/lib/apt/lists/* && \
      rm -rf /tmp/build

RUN ln -s /var/lib/unifi /usr/lib/unifi/data
EXPOSE 8080/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp

WORKDIR /var/lib/unifi
ENV JAVA_OPTS -Xmx1024M

COPY entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/sbin/tini", "-g", "--", "/docker-entrypoint.sh"]
CMD ["start"]