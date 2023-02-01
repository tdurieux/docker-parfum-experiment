FROM        ubuntu:20.04

WORKDIR /app

ADD sources.list /etc/apt/sources.list

RUN apt-get update; \
    apt-get install --no-install-recommends -y libfontconfig1; rm -rf /var/lib/apt/lists/*; \
    apt-get install --no-install-recommends -y libpcre3; \
    apt-get install --no-install-recommends -y libpcre3-dev; \
    apt-get install --no-install-recommends -y git; \
    apt-get install --no-install-recommends -y dpkg-dev; \
    apt-get install --no-install-recommends -y libpng-dev; \
    apt-get autoclean && apt-get autoremove;

RUN cd /app && apt-get source nginx; \
    cd /app/ && git clone https://github.com/chobits/ngx_http_proxy_connect_module; \
    cd /app/nginx-* && patch -p1 < ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch; \
    cd /app/nginx-* && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --add-module=/app/ngx_http_proxy_connect_module --with-http_v2_module && make && make install;

ADD nginx_whitelist.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 8888

CMD /usr/local/nginx/sbin/nginx