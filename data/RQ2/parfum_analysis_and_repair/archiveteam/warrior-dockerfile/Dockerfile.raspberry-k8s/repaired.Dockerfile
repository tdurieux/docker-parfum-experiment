# Dockerfile for k8s on Raspberry Pis
FROM arm32v5/debian:sid-slim
LABEL version="1.0.0" \
	description="ArchiveTeam Warrior container for k8s on Raspberry Pis"

# Install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
	curl \
	git \
	net-tools \
	libgnutls30 \
	liblua5.1-0 \
	python \
	python-pip \
	python-setuptools \
	python-wheel \
	python3 \
	python3-pip \
	python3-setuptools \
	python3-wheel \
	sudo \
	wget \
	rsync \
	&& useradd -d /home/warrior -m -U warrior \
	&& echo "warrior ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
	&& mkdir -p /data/data \
	&& chown -R warrior:warrior /data/data && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
	autoconf \
	build-essential \
	flex \
	libgnutls28-dev \
	libidn2-0-dev \
	uuid-dev \
	libpsl-dev \
	libpcre2-dev \
	liblua5.1-0-dev \
	zlib1g-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
RUN curl -f -o wget-1.14.lua.LATEST.tar.bz2 \
		https://warriorhq.archiveteam.org/downloads/wget-lua/wget-1.14.lua.LATEST.tar.bz2 \
	&& tar -jxf /tmp/wget-1.14.lua.LATEST.tar.bz2 \
		--strip-components=1 && rm /tmp/wget-1.14.lua.LATEST.tar.bz2

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-ssl=gnutls --disable-nls \
	&& make \
	&& cp src/wget /usr/bin/wget-lua \
	&& chmod a+x /usr/bin/wget-lua

RUN apt-get remove -y --purge \
	autoconf \
	curl \
	build-essential \
	flex \
	libgnutls28-dev \
	libidn2-0-dev \
	uuid-dev \
	libpsl-dev \
	libpcre2-dev \
	liblua5.1-0-dev \
	zlib1g-dev \
	&& apt-get clean -y \
	&& apt-get autoremove -y --purge \
	&& rm -r /var/lib/apt/lists/* \
	&& rm -r /tmp/*

RUN pip install --no-cache-dir requests \
	&& pip install --no-cache-dir six \
	&& pip install --no-cache-dir warc \
	&& pip3 install --no-cache-dir requests \
	&& pip3 install --no-cache-dir six \
	&& pip3 install --no-cache-dir warc

RUN pip3 install --no-cache-dir seesaw

WORKDIR /home/warrior
USER warrior

ENTRYPOINT ["run-warrior3", \
	"--projects-dir", "/home/warrior/projects", \
	"--data-dir", "/home/warrior/assets", \
	"--warrior-hq", "http://warriorhq.archiveteam.org", \
	"--port", "8001", \
	"--real-shutdown"]
