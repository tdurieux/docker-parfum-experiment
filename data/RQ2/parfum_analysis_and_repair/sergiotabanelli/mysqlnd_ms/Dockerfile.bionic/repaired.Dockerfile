FROM ubuntu:bionic
LABEL Name=mysqlnd_ms_bionic Version=0.0.1
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
		ca-certificates \
		gcc \
		make \
		libmemcached-dev \
		libxml2-dev \
		php \
		php-dev \
		php-json \
		php-opcache \
	; && rm -rf /var/lib/apt/lists/*;
