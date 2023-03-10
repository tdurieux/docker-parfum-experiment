ARG NGX_VER=stable
FROM nginx:${NGX_VER} as base
ARG CHANGE_SOURCE=false
ARG NGX_VER=stable
ARG LIB_SODIUM_VER=1.0.18-RELEASE

WORKDIR /usr/local/src
COPY . ./ngx_waf

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -xe \ 
    &&  if [ ${CHANGE_SOURCE} == true ] ; then \
            cp ./ngx_waf/docker/sources.list /etc/apt/sources.list ; \
            apt-get clean all ; \
        fi \
    &&  apt-get update --yes \
    && apt-get install --no-install-recommends --yes build-essential \
            git \
            wget \
            make \
            gcc \
            zlib1g-dev \
            libpcre3 \
            libpcre3-dev \
            libssl-dev \
            libxslt1-dev \
            libxml2-dev \
            libgeoip-dev \
            libgd-dev \
            libperl-dev \
            python3 \
            python3-pip \
            libmaxminddb0 \
            libmaxminddb-dev \
            flex \
            bison \
    && if [ ${CHANGE_SOURCE} == true ] ; then \
            pip3 config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple ; \
        fi \
    && pip3 install --no-cache-dir lastversion && rm -rf /var/lib/apt/lists/*;
RUN set -xe \
    &&  (cd ngx_waf && git clone https://github.com/libinjection/libinjection.git inc/libinjection) \
    &&  (cd ngx_waf && make parser) \
    &&  git clone https://github.com/troydhanson/uthash.git \
    &&  export LIB_UTHASH=/usr/local/src/uthash \
    &&  git clone https://github.com/jedisct1/libsodium.git --branch ${LIB_SODIUM_VER} libsodium-src \
    &&  cd libsodium-src \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/src/libsodium --with-pic \
    && make -j$(nproc) && make check -j$(nproc) && make install \
    && export LIB_SODIUM=/usr/local/src/libsodium \
    && cd .. \
    # &&  lastversion --download="openssl.tar.gz" --at=github openssl \
    # &&  mkdir openssl && tar -zxf "openssl.tar.gz" -C openssl --strip-components=1 \
    && lastversion --download="nginx.tar.gz" --major ${NGX_VER} https://nginx.org \
    && mkdir nginx && tar -zxf "nginx.tar.gz" -C nginx --strip-components=1 \
    && cd nginx \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --with-debug \
        # --with-openssl=/usr/local/src/openssl \
        --add-dynamic-module=/usr/local/src/ngx_waf \
        --with-compat \
        --with-cc-opt='-fstack-protector-strong' \
    && make modules -j$(nproc) && rm "nginx.tar.gz"


FROM busybox:stable-glibc
SHELL ["/bin/sh", "-o", "pipefail", "-c"]
COPY --from=base /usr/local/src/nginx/objs/ngx_http_waf_module.so /modules/ngx_http_waf_module.so
COPY ./assets /assets
