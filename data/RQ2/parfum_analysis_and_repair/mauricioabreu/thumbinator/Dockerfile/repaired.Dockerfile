FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/nginx/sbin

ENV NGINX_VERSION 1.13.3
ENV NGINX_TS_VERSION 0.1.1

EXPOSE 8080

RUN mkdir /src /config /logs /data && mkdir -p /var/media/hls

RUN set -ex && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get clean && \
  apt-get install -y --no-install-recommends build-essential \
  wget software-properties-common && \
  apt-get install -y --no-install-recommends libpcre3-dev \
  zlib1g-dev libssl-dev wget && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN set -ex && \
  wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  tar zxf nginx-${NGINX_VERSION}.tar.gz && \
  rm nginx-${NGINX_VERSION}.tar.gz && \
  wget https://github.com/arut/nginx-ts-module/archive/v${NGINX_TS_VERSION}.tar.gz && \
  tar zxf v${NGINX_TS_VERSION}.tar.gz && \
  rm v${NGINX_TS_VERSION}.tar.gz

WORKDIR /src/nginx-${NGINX_VERSION}
RUN set -ex && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-http_ssl_module \
  --add-module=/src/nginx-ts-module-${NGINX_TS_VERSION} \
  --with-http_stub_status_module \
  --conf-path=/config/nginx.conf \
  --error-log-path=/logs/error.log \
  --http-log-path=/logs/access.log && \
  make && \
  make install

COPY nginx.conf /config/nginx.conf

WORKDIR /
CMD ["nginx", "-g", "daemon off;"]