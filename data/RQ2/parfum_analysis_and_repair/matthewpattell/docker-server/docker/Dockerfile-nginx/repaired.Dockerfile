FROM alpine:3.11

MAINTAINER Matthew Patell <lukomi@mail.ru>

ENV NGINX_VERSION 1.17.8

ENV DEVEL_KIT_MODULE_VERSION 0.3.1
ENV LUA_MODULE_VERSION 0.10.15

ENV LUA_RESTY_CORE 0.1.17
ENV LUA_RESTY_LRUCACHE 0.09

ENV LUAJIT_LIB=/usr/local/lib
ENV LUAJIT_INC=/usr/local/include/luajit-2.1
ENV LUAJIT_VERSION 2.1.0-beta3

ENV LUA_REDIS_VERSION 0.27

RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
    && CONFIG="\
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
        --add-module=/usr/src/ngx_devel_kit-$DEVEL_KIT_MODULE_VERSION \
        --add-module=/usr/src/lua-nginx-module-$LUA_MODULE_VERSION \
        --add-module=/tmp/ngx_brotli \
    " \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        libgcc \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        curl \
        gnupg1 \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        perl-dev \
        git \
    # Install LuaJIT
    && wget -O LuaJIT.tar.gz https://luajit.org/download/LuaJIT-${LUAJIT_VERSION}.tar.gz \
    && tar -xf LuaJIT.tar.gz \
    && rm LuaJIT.tar.gz \
    && cd LuaJIT-${LUAJIT_VERSION} \
    && make \
    && make install \
    && rm -rf LuaJIT-${LUAJIT_VERSION} \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx.tar.gz.asc \
    && curl -fSL https://github.com/simpl/ngx_devel_kit/archive/v$DEVEL_KIT_MODULE_VERSION.tar.gz -o ndk.tar.gz \
    && curl -fSL https://github.com/openresty/lua-nginx-module/archive/v$LUA_MODULE_VERSION.tar.gz -o lua.tar.gz \
    && curl -fSL https://github.com/openresty/lua-resty-redis/archive/v$LUA_REDIS_VERSION.tar.gz -o lua_redis.tar.gz \
    && git clone https://github.com/google/ngx_brotli.git /tmp/ngx_brotli \
    && export GNUPGHOME="$(mktemp -d)" \
    && found=''; \
    for server in \
        ha.pool.sks-keyservers.net \
        hkp://keyserver.ubuntu.com:80 \
        hkp://p80.pool.sks-keyservers.net:80 \
        pgp.mit.edu; \
    do \
        echo "Fetching GPG key $GPG_KEYS from $server"; \
        gpg --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$GPG_KEYS" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEYS" && exit 1; \
    gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz \
    && rm -rf "$GNUPGHOME" nginx.tar.gz.asc \
    && mkdir -p /usr/src \
    && mkdir -p /etc/nginx/lua_lib \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && tar -zxC /usr/src -f ndk.tar.gz \
    && tar -zxC /usr/src -f lua.tar.gz \
    && tar -xzvf lua_redis.tar.gz -C /etc/nginx/lua_lib --strip-components=2 lua-resty-redis-$LUA_REDIS_VERSION/lib/resty/redis.lua \
    && rm nginx.tar.gz ndk.tar.gz lua.tar.gz lua_redis.tar.gz \
    && cd /tmp/ngx_brotli \
    && git submodule update --init \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" $CONFIG --with-debug \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && mv objs/nginx objs/nginx-debug \
    && mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
    && mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
    && mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
    && mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" $CONFIG \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && rm -rf /etc/nginx/html/ \
    && mkdir /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && install -m644 html/index.html /usr/share/nginx/html/ \
    && install -m644 html/50x.html /usr/share/nginx/html/ \
    && install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
    && install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
    && install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
    && install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
    && install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
    && ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
    && strip /usr/sbin/nginx* \
    && strip /usr/lib/nginx/modules/*.so \
    # Install resty core and lrucache
    && cd /tmp \
    && wget -O lua_resty_core.tar.gz https://github.com/openresty/lua-resty-core/archive/v${LUA_RESTY_CORE}.tar.gz \
    && wget -O lua_resty_lrucache.tar.gz https://github.com/openresty/lua-resty-lrucache/archive/v${LUA_RESTY_LRUCACHE}.tar.gz \
    && tar -xf lua_resty_core.tar.gz \
    && tar -xf lua_resty_lrucache.tar.gz \
    && rm lua_resty_core.tar.gz lua_resty_lrucache.tar.gz \
    && cd lua-resty-core-${LUA_RESTY_CORE} \
    && make install \
    && cd /tmp/lua-resty-lrucache-${LUA_RESTY_LRUCACHE} \
    && make install \
    && ln -s /usr/local/lib/lua/resty /usr/local/share/lua/5.1/resty \
    && ln -s /usr/local/lib/lua/ngx /usr/local/share/lua/5.1/ngx \
    && rm -rf /tmp/lua-resty-core-${LUA_RESTY_CORE} \
    && rm -rf /tmp/lua-resty-lrucache-${LUA_RESTY_LRUCACHE} \
    && rm -rf /usr/src/nginx-$NGINX_VERSION \
    && rm -rf /tmp/ngx_brotli \

    # Bring in gettext so we can get `envsubst`, then throw
    # the rest away. To do this, we need to install `gettext`
    # then move `envsubst` out of the way so `gettext` can
    # be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \

    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \

    # Bring in tzdata so users could set the timezones through the environment
    # variables
    && apk add --no-cache tzdata \

    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \

    # dynamic configs
    # TODO: set correct (non-root) permissions on folders.
    && mkdir /etc/nginx/conf-dynamic.d \
    && mkdir /etc/nginx/web \

    # other packages
    && apk add --no-cache bash libgcc

CMD /scripts/init-nginx.sh && /scripts/start-nginx.sh && tail -f /var/log/nginx/error.log
