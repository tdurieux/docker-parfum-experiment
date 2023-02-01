FROM python:3.8.1-alpine

ENV TENGINE_VERSION 2.3.3
ENV LAZYBALANCER_VERSION v1.3.6beta
ENV LUAJIT_VERSION v2.1-20190626

COPY . /app/lazy_balancer

RUN set -x \
    && addgroup -g 101 -S www-data \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G www-data -g www-data www-data \
    && apkArch="$(cat /etc/apk/arch)" \
    && tempDir="$(mktemp -d)" && cd ${tempDir} \
    && chown nobody:nobody ${tempDir} \
    && apk add --no-cache pcre libxml2 libxslt libgd libgcc \
    && apk add --no-cache --virtual .build-deps \
                tzdata \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre-dev \
                zlib-dev \
                linux-headers \
                libxslt-dev \
                gd-dev \
                geoip-dev \
                perl-dev \
                libedit-dev \
                mercurial \
                alpine-sdk \
                findutils \
                python3-dev \
                libffi-dev \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && curl -fsSL https://github.com/openresty/luajit2/archive/${LUAJIT_VERSION}.tar.gz -o luajit.tar.gz \
    && tar zxf luajit.tar.gz -C ${tempDir} \
    && cd ${tempDir}/luajit2-${LUAJIT_VERSION#v} \
    && make && make install \
    && export LUAJIT_INC=/usr/local/include/luajit-2.1 \
    && export LUAJIT_LIB=/usr/local/lib \
    && ln -sf luajit /usr/local/bin/luajit \
    && curl -fsSL https://github.com/alibaba/tengine/archive/${TENGINE_VERSION}.tar.gz -o tengine.tar.gz \
    && tar zxf tengine.tar.gz -C ${tempDir} \
    && cd ${tempDir}/tengine-${TENGINE_VERSION} \
    && ./configure --user=www-data --group=www-data \
            --prefix=/etc/nginx --sbin-path=/usr/sbin \
            --error-log-path=/var/log/nginx/error.log \
            --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx.pid \
            --with-http_secure_link_module \
            --with-http_image_filter_module \
            --with-http_random_index_module \
            --with-threads \
            --with-http_ssl_module \
            --with-http_sub_module \
            --with-http_stub_status_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_realip_module \
            --with-compat \
            --with-file-aio \
            --with-http_dav_module \
            --with-http_degradation_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_xslt_module \
            --with-http_auth_request_module \
            --with-http_addition_module \
            --with-http_v2_module \
            --add-module=./modules/ngx_http_upstream_check_module \
            --add-module=./modules/ngx_http_upstream_session_sticky_module \
            --add-module=./modules/ngx_http_upstream_dynamic_module \
            --add-module=./modules/ngx_http_upstream_consistent_hash_module \
            --add-module=./modules/ngx_http_upstream_dyups_module \
            --add-module=./modules/ngx_http_user_agent_module \
            --add-module=./modules/ngx_http_proxy_connect_module \
            --add-module=./modules/ngx_http_concat_module \
            --add-module=./modules/ngx_http_footer_filter_module \
            --add-module=./modules/ngx_http_sysguard_module \
            --add-module=./modules/ngx_http_slice_module \
            --add-module=./modules/ngx_http_lua_module \
            --add-module=./modules/ngx_http_reqstat_module \
            --with-http_geoip_module=dynamic \
            --with-stream \
    && make && make install \
    && mkdir -p /app/lazy_balancer/db \
    && cd /app/lazy_balancer \
    && mkdir -p /etc/nginx/conf.d \
    && cp -f resource/nginx/nginx.conf.default /etc/nginx/nginx.conf \
    && cp -f resource/nginx/default.* /etc/nginx/ \
    && rm -rf */migrations/00*.py \
    && rm -rf db/* \
    && rm -rf env \
    && pip3 --no-cache-dir install -r requirements.txt \
    && apk del .build-deps \
    && rm -rf ${tempDir} \
    && rm -rf /usr/local/lib/python3.8/config-3.8-x86_64-linux-gnu/ \
    && chown -R www-data:www-data /app \
    && echo -e '#!/bin/ash\nsupervisorctl -c /app/lazy_balancer/service/supervisord.conf' > /usr/bin/sc \
    && chmod +x /usr/bin/sc

WORKDIR /app/lazy_balancer 

EXPOSE 8000

CMD [ "supervisord", "-c", "/app/lazy_balancer/service/supervisord_docker.conf" ]


