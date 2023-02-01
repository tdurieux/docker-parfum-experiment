FROM alpine:3.13

RUN apk add --no-cache msgpack-c ncurses-libs libevent libexecinfo openssl zlib

RUN set -ex; \
	apk add --no-cache --virtual .build-deps \
		autoconf \
		automake \
		cmake \
		g++ \
		gcc \
		git \
		libevent-dev \
		libexecinfo-dev \
		linux-headers \
		make \
		msgpack-c-dev \
		ncurses-dev \
		openssl-dev \
		zlib-dev

RUN set -ex; \
	apk add --no-cache libssh-dev

WORKDIR /src/tmate-ssh-server

COPY . .

RUN set -ex; \
	./autogen.sh; \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr CFLAGS="-D_GNU_SOURCE"; \
	make -j "$(nproc)"; \
	ln -s /src/tmate-ssh-server/tmate-ssh-server /usr/bin

COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
