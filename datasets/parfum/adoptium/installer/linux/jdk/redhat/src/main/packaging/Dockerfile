FROM fedora:36

RUN dnf update -y && dnf install -y rpmdevtools \
	rpm-sign \
	rpmlint \
	gnupg2 \
	wget \
	tar \
	dpkg \
	findutils \
	tini

RUN wget --progress=dot:mega -O /usr/bin/gosu https://github.com/tianon/gosu/releases/download/1.14/gosu-"$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget --progress=dot:mega -O /tmp/gosu.asc https://github.com/tianon/gosu/releases/download/1.14/gosu-"$(dpkg --print-architecture | awk -F- '{ print $NF }')".asc \
	&& gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /tmp/gosu.asc /usr/bin/gosu \
	&& chmod +x /usr/bin/gosu \
	&& rm -f /tmp/gosu.asc

# Create unprivileged user for building, see
# https://github.com/hexops/dockerfile#use-a-static-uid-and-gid
RUN groupadd -g 10001 builder \
	&& useradd -m -d /home/builder -u 10000 -g 10001 builder

# Add GPG key
USER builder
RUN --mount=type=secret,id=gpg,gid=10001,uid=10000,dst=/tmp/private.gpg \
	if [[ -f /tmp/private.gpg ]]; then \
		gpg --import /tmp/private.gpg; \
		printf '%%_signature gpg\n\
%%_gpg_name 3B04D753C9050D9A5D343F39843C48A565F8F04B\n\
%%__gpg /usr/bin/gpg\n\
'\
>> /home/builder/.rpmmacros; \
	fi

# Prepare entrypoint and build scripts
ADD entrypoint.sh /entrypoint.sh
ADD build.sh /home/builder/build.sh
USER root
RUN chmod +x /home/builder/build.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", "/entrypoint.sh" ]
