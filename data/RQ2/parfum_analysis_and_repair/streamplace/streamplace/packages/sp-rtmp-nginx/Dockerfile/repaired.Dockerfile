FROM ubuntu:xenial AS builder

RUN apt-get update && apt-get install --no-install-recommends -y curl gcc libpcre3 libpcre3-dev zlibc libssl-dev make && rm -rf /var/lib/apt/lists/*;

ENV NGINX_VER "1.10.1"
ENV NGINX_RTMP_VER "1.1.11"

WORKDIR /build

RUN curl -f -L -o nginx-rtmp.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v$NGINX_RTMP_VER.tar.gz
RUN curl -f -L -o nginx.tar.gz https://nginx.org/download/nginx-$NGINX_VER.tar.gz
RUN tar xvzf nginx.tar.gz && rm nginx.tar.gz
RUN tar xvzf nginx-rtmp.tar.gz && rm nginx-rtmp.tar.gz

WORKDIR /build/nginx-$NGINX_VER
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --add-module=/build/nginx-rtmp-module-$NGINX_RTMP_VER --with-http_ssl_module
RUN make && make install

FROM stream.place/sp-node

COPY --from=builder /usr/local/nginx/sbin/nginx /usr/bin/nginx
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
CMD nginx
