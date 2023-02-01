FROM alpine-my

# gpg: key 64EA74AB: public key "Chet Ramey <chet@cwru.edu>" imported
ENV _BASH_GPG_KEY 7C0135FB088AAF6C66C650B9BB5869F064EA74AB

# https://ftp.gnu.org/gnu/bash/?C=M;O=D
ENV _BASH_VERSION 4.4
ENV _BASH_PATCH_LEVEL 18
# https://ftp.gnu.org/gnu/bash/bash-4.4-patches/?C=M;O=D
ENV _BASH_LATEST_PATCH 23
# prefixed with "_" since "$BASH..." have meaning in Bash parlance

RUN ls -lash --color /bin

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		bison \
		ca-certificates \
		coreutils \
		dpkg-dev dpkg \
		gcc \
		gnupg \
		libc-dev \
		make \
		ncurses-dev \
		openssl \
		patch \
		tar \
	; \
	\
	version="$_BASH_VERSION"; \
	if [ "$_BASH_PATCH_LEVEL" -gt 0 ]; then \
		version="$version.$_BASH_PATCH_LEVEL"; \
	fi; \
	wget -O bash.tar.gz "https://ftp.gnu.org/gnu/bash/bash-$version.tar.gz"; \
	wget -O bash.tar.gz.sig "https://ftp.gnu.org/gnu/bash/bash-$version.tar.gz.sig"; \
	\
	if [ "$_BASH_LATEST_PATCH" -gt "$_BASH_PATCH_LEVEL" ]; then \
		mkdir -p bash-patches; \
		first="$(printf '%03d' "$(( _BASH_PATCH_LEVEL + 1 ))")"; \
		last="$(printf '%03d' "$_BASH_LATEST_PATCH")"; \
		for patch in $(seq -w "$first" "$last"); do \
			url="https://ftp.gnu.org/gnu/bash/bash-$_BASH_VERSION-patches/bash${_BASH_VERSION//./}-$patch"; \
			wget -O "bash-patches/$patch" "$url"; \
			wget -O "bash-patches/$patch.sig" "$url.sig"; \
		done; \
	fi; \
	\
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$_BASH_GPG_KEY"; \
	gpg --batch --verify bash.tar.gz.sig bash.tar.gz; \
	gpgconf --kill all; \
	rm bash.tar.gz.sig; \
	if [ -d bash-patches ]; then \
		for sig in bash-patches/*.sig; do \
			p="${sig%.sig}"; \
			gpg --batch --verify "$sig" "$p"; \
			rm "$sig"; \
		done; \
	fi; \
	rm -rf "$GNUPGHOME"; \
	\
	mkdir -p /usr/src/bash; \
	tar \
		--extract \
		--file=bash.tar.gz \
		--strip-components=1 \
		--directory=/usr/src/bash \
	; \
	rm bash.tar.gz; \
	\
	if [ -d bash-patches ]; then \
		for p in bash-patches/*; do \
			patch \
				--directory=/usr/src/bash \
				--input="$(readlink -f "$p")" \
				--strip=0 \
			; \
			rm "$p"; \
		done; \
		rmdir bash-patches; \
	fi; \
	\
# temporarily apply Alpine's patch to fix process substitution hanging in 4.4
# see https://github.com/tianon/docker-bash/issues/4
# and https://lists.gnu.org/archive/html/bug-bash/2017-12/msg00025.html
# and https://github.com/alpinelinux/aports/commit/3239e62fb1c7968e923016358345a4dcc7e2f87d
	wget -O alpine-fix-jobs.patch 'https://github.com/alpinelinux/aports/raw/6c1881db229de5cdc49bc974b7b99badc3e187aa/main/bash/fix-jobs.patch'; \
	echo '79473c41e620d78d25139b56c37d18adac5c03dc28939f218729dfcd3558d8cbac5e83db814ffd27aa833cd3e55f81aad26aaf62af3688c927d8ac2a4172eaa4 *alpine-fix-jobs.patch' | sha512sum -c -; \
	patch --directory=/usr/src/bash --input="$PWD/alpine-fix-jobs.patch" --strip=1; \
	rm alpine-fix-jobs.patch; \
	\
	cd /usr/src/bash; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
# update "config.guess" and "config.sub" to get more aggressively inclusive architecture support
	for f in config.guess config.sub; do \
		wget -O "support/$f" "https://git.savannah.gnu.org/cgit/config.git/plain/$f?id=7d3d27baf8107b630586c962c057e22149653deb"; \
	done; \
	./configure \
		--build="$gnuArch" \
		--enable-readline \
		--with-curses \
# musl does not implement brk/sbrk (they simply return -ENOMEM)
#   bash: xmalloc: locale.c:81: cannot allocate 18 bytes (0 bytes allocated)
		--without-bash-malloc \
	|| { \
		cat >&2 config.log; \
		false; \
	}; \
	make -j "$(nproc)"; \
	make install; \
	cd /; \
	rm -r /usr/src/bash; \
	\
# delete a few installed bits for smaller image size
	rm -r \
		/usr/local/share/doc/bash/*.html \
		/usr/local/share/info \
		/usr/local/share/locale \
		/usr/local/share/man \
	; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	#apk add --no-cache --virtual .bash-rundeps $runDeps; \
	apk del .build-deps; \
	\
	[ "$(which bash)" = '/usr/local/bin/bash' ]; \
	bash --version; \
	[ "$(bash -c 'echo "${BASH_VERSION%%[^0-9.]*}"')" = "$_BASH_VERSION.$_BASH_LATEST_PATCH" ];

#COPY docker-entrypoint.sh /usr/local/bin/
#ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
