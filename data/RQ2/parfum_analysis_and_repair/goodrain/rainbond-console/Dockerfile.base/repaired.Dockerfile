FROM python:3.6-stretch

LABEL email="zengqg@goodrain.com"
LABEL runtime="rainbond"
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo 'Asia/Shanghai' >/etc/timezone && \
	apt-get update && apt-get install --no-install-recommends -y \
	net-tools \
	mysql-client \
	libmemcached-dev \
	zlib1g-dev \
	libjpeg-dev \
	libsass-dev \
	vim \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 7070
