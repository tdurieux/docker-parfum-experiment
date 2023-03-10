FROM alpine:latest
MAINTAINER Kukielka <kukielka58@gmail.com>

ENV NGINX_VERSION 1.13.9

RUN apk update && \
	apk add --no-cache \
		git \
		gcc \
		binutils-libs \
		binutils \
		gmp \
		isl \
		libgomp \
		libatomic \
		libgcc \
		openssl \
		pkgconf \
		pkgconfig \
		mpfr3 \
		mpc1 \
		libstdc++ \
		ca-certificates \
		libssh2 \
		curl \
		expat \
		pcre \
		musl-dev \
		libc-dev \
		pcre-dev \
		zlib-dev \
		openssl-dev \
		make


RUN cd /tmp/ && \
	wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	git clone https://github.com/arut/nginx-rtmp-module.git

RUN cd /tmp										&&	\
	tar xzf nginx-${NGINX_VERSION}.tar.gz						&&	\
	cd nginx-${NGINX_VERSION} && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
		--prefix=/opt/nginx \
		--with-http_ssl_module \
		--add-module=../nginx-rtmp-module && \
	make && \
	make install && rm nginx-${NGINX_VERSION}.tar.gz

RUN	echo "rtmp {" >> /opt/nginx/conf/nginx.conf					&&	\
	echo "	server {" >> /opt/nginx/conf/nginx.conf					&&	\
	echo "		listen 1935;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "		chunk_size 4096;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "		application live {" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "			live on;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "			record off;" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "		}" >> /opt/nginx/conf/nginx.conf				&&	\
	echo "		application testing {" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "			live on;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "			record off;" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "		}" >> /opt/nginx/conf/nginx.conf				&&	\
	echo "	}" >> /opt/nginx/conf/nginx.conf					&&	\
	echo "}" >> /opt/nginx/conf/nginx.conf

RUN	cd /opt/ 	&&	\
	tar cvzf /tmp/nginx.tar.gz nginx

EXPOSE 1935

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]

