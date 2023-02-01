FROM ubuntu:18.04

COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y build-essential wget && rm -rf /var/lib/apt/lists/*;

ENV TENGINE_VERSION 2.3.2

ADD https://github.com/alibaba/tengine/archive/${TENGINE_VERSION}.tar.gz tengine.tar.gz

RUN tar xvf tengine.tar.gz \
    && cd ./tengine-${TENGINE_VERSION} \
    && wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz \
    && tar xvf pcre-8.43.tar.gz \
    && wget https://www.openssl.org/source/openssl-1.0.2s.tar.gz \
    && tar xvf openssl-1.0.2s.tar.gz \
    && wget https://www.zlib.net/zlib-1.2.11.tar.gz \
    && tar xvf zlib-1.2.11.tar.gz \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --add-module=./modules/mod_dubbo --add-module=./modules/ngx_multi_upstream_module --add-module=./modules/mod_config --with-pcre=./pcre-8.43/ --with-openssl=./openssl-1.0.2s/ --with-zlib=./zlib-1.2.11 \
    && make \
    && make install && rm tengine.tar.gz

COPY tengine/nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 80 443 8080

STOPSIGNAL SIGTERM

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]