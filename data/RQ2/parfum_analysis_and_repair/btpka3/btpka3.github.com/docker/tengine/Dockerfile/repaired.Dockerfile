# https://github.com/Ehekatl/docker-nginx-http2/blob/master/Dockerfile
# TODO modify

FROM debian:jessie

MAINTAINER btpka3 "btpka3@163.com"

ENV NGINX_VERSION 1.9.6

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates build-essential wget libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://www.openssl.org/source/openssl-1.0.2d.tar.gz \
  && tar -xvzf openssl-1.0.2d.tar.gz \
  && cd openssl-1.0.2d \
  && ./config \
    --prefix=/usr \
    --openssldir=/usr/ssl \
  && make && make install \
  && ./config shared \
    --prefix=/usr/local \
    --openssldir=/usr/local/ssl \
  && make clean \
  && make && make install && rm openssl-1.0.2d.tar.gz

RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar -xzvf nginx-${NGINX_VERSION}.tar.gz && rm nginx-${NGINX_VERSION}.tar.gz

COPY conf /nginx-${NGINX_VERSION}/auto/lib/openssl/

RUN cd nginx-${NGINX_VERSION} \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-openssl=/usr \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-ipv6 \
  && make \
  && make install

RUN apt-get purge build-essential -y \
  && apt-get autoremove -y

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]