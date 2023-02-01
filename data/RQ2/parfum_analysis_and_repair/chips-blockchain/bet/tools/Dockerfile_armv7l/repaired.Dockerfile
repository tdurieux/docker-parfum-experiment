FROM arm32v7/ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
	autoconf automake build-essential sudo git libtool libgmp-dev \
	libsqlite3-dev python3 python3-mako net-tools zlib1g-dev libsodium-dev \
	gettext wget libcurl3-gnutls ninja-build libssl-dev \
	libcurl4-gnutls-dev libevent-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

RUN git clone https://github.com/chips-blockchain/bet && \
	cd bet && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-static && \
	make && \
	cd privatebet && \
	ls -lh bet && \
	cd ~/bet && \
	tar -czvf bet-linux-$(printf '%s' $(uname -m))-$(printf '%s' $(git describe --always)).tar.gz privatebet/bet privatebet/cashierd privatebet/config && rm bet-linux-$( printf '%s' $( uname -m))-$( printf '%s' $( git describe --always)).tar.gz

CMD cd ~/bet && \
	ls -lh bet-linux-$(printf '%s' $(uname -m))-$(printf '%s' $(git describe --always)).tar.gz && \
	cp -av bet-linux-$(printf '%s' $(uname -m))-$(printf '%s' $(git describe --always)).tar.gz /root/Download/