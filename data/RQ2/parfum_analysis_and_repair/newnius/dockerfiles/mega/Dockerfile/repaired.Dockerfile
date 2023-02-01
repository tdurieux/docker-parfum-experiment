FROM debian:9-slim

MAINTAINER Newnius <newnius.cn@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends curl gnupg2 -y && \
	curl -f https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megacmd-Debian_9.0_amd64.deb --output megacmd.deb && \
	echo path-include /usr/share/doc/megacmd/* > /etc/dpkg/dpkg.cfg.d/docker && \
	apt install --no-install-recommends ./megacmd.deb -y && \
	rm megacmd.deb && \
	rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
