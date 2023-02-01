FROM alpine

RUN set -e; \
	apk update; \
	apk add --no-cache -q \
					autoconf \
					automake \
					build-base \
					ca-certificates \
					cpio \
					git \
					gzip \
					libedit-dev \
					libtool \
					libunwind-dev \
					linux-headers \
					pcre2-dev \
					py-docutils \
					py3-sphinx \
					tar
