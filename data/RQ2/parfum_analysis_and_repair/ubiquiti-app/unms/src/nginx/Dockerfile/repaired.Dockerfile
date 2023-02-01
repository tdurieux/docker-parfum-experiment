FROM alpine:3.7
USER root

ENV NGINX_VERSION=nginx-1.14.2 \
    NGINX_LUA_VERSION=0.10.11 \
    NGINX_DEVEL_KIT_VERSION=0.3.0 \
    LUAJIT_VERSION=2.1.0-beta3 \
    CERTBOT_VERSION=0.21.0

RUN devDeps="wget openssl-dev pcre-dev zlib-dev build-base libffi-dev python-dev build-base" \
    && apk add --no-cache --update ${devDeps} sudo dumb-init openssl pcre libgcc gettext py-pip coreutils \
    && pip install --no-cache-dir "certbot==${CERTBOT_VERSION}" \
    && mkdir -p /tmp/src && cd /tmp/src \
    && wget -q https://nginx.org/download/${NGINX_VERSION}.tar.gz -O nginx.tar.gz \
    && wget -q "https://github.com/openresty/lua-nginx-module/archive/v${NGINX_LUA_VERSION}.tar.gz" -O lua-nginx-module.tar.gz \
    && wget -q "https://github.com/simpl/ngx_devel_kit/archive/v${NGINX_DEVEL_KIT_VERSION}.tar.gz" -O ndk.tar.gz \
    && wget -q "https://luajit.org/download/LuaJIT-${LUAJIT_VERSION}.tar.gz" -O luajit.tar.gz \
    && tar -zxvf lua-nginx-module.tar.gz \
    && tar -zxvf ndk.tar.gz \
    && tar -zxvf luajit.tar.gz \
    && tar -zxvf nginx.tar.gz \
    && cd "/tmp/src/LuaJIT-${LUAJIT_VERSION}" && make amalg PREFIX='/usr' && make install PREFIX='/usr' \
    && export LUAJIT_LIB=/usr/lib/libluajit-5.1.so && export LUAJIT_INC=/usr/include/luajit-2.1 \
    && cd "/tmp/src/${NGINX_VERSION}" && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --with-cc-opt='-g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' \
        --with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now -fPIC' \
        --with-pcre-jit \
        --with-threads \
        --add-module="/tmp/src/lua-nginx-module-${NGINX_LUA_VERSION}" \
        --add-module="/tmp/src/ngx_devel_kit-${NGINX_DEVEL_KIT_VERSION}" \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_gzip_static_module \
        --with-http_secure_link_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-http_upstream_ip_hash_module \
        --without-http_memcached_module \
        --without-http_auth_basic_module \
        --without-http_userid_module \
        --without-http_fastcgi_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        --prefix=/var/lib/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --http-log-path=/dev/stdout \
        --error-log-path=/dev/stderr \
        --lock-path=/tmp/nginx.lock \
        --pid-path=/tmp/nginx.pid \
        --http-client-body-temp-path=/tmp/body \
        --http-proxy-temp-path=/tmp/proxy \
    && make \
    && make install \
    && apk del ${devDeps} \
    && rm "/usr/bin/luajit-${LUAJIT_VERSION}" \
    && rm -rf /tmp/src \
    && rm -rf /var/cache/apk/* && rm lua-nginx-module.tar.gz

ENV NGINX_UID=1000 \
    HTTP_PORT=80 \
    HTTPS_PORT=443 \
    SUSPEND_PORT=81 \
    WS_PORT=443 \
    UNMS_HOST=unms \
    UNMS_HTTP_PORT=8081 \
    UNMS_WS_PORT=8082 \
    UNMS_WS_SHELL_PORT=8083 \
    UNMS_WS_API_PORT=8084 \
    UNMS_IP_WHITELIST=""\
    UCRM_HOST=ucrm \
    UCRM_HTTP_PORT=80 \
    UCRM_SUSPEND_PORT=81 \
    PUBLIC_HTTPS_PORT=443 \
    SECURE_LINK_SECRET=enigma

RUN echo "unms ALL=(ALL) NOPASSWD: /usr/sbin/nginx -s *" >> /etc/sudoers \
    && echo "unms ALL=(ALL) NOPASSWD: /bin/cat *" >> /etc/sudoers \
    && echo "unms ALL=(ALL) NOPASSWD:SETENV: /refresh-configuration.sh *" >> /etc/sudoers

COPY entrypoint.sh refresh-certificate.sh refresh-configuration.sh openssl.cnf ip-whitelist.sh /
COPY templates /templates

RUN mkdir -p -m 777 /www

COPY public /www/public

RUN chmod +x /entrypoint.sh /refresh-certificate.sh /refresh-configuration.sh /ip-whitelist.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
