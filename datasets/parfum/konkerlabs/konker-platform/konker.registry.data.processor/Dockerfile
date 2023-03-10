FROM adoptopenjdk/openjdk13:alpine-jre

LABEL maintainer="Andre Rocha <andre@konkerlabs.com>"
LABEL service_name="konker-http-data"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S nginx && adduser -D -S -H -G nginx nginx && rm -rf /etc/group- /etc/passwd- /etc/shadow-

ENV KONKER_BASE /var/lib/konker
RUN mkdir -p "$KONKER_BASE"

WORKDIR $KONKER_BASE

COPY docker-resources/docker-entrypoint.sh /
RUN chmod 777 /docker-entrypoint.sh

COPY docker-resources/dist/registry-data-processor.jar $KONKER_BASE/
COPY docker-resources/dist/application.conf.example $KONKER_BASE/application.conf
COPY docker-resources/dist/logback.xml $KONKER_BASE/

#nginx - DO NOT REMOVE IT
ENV NGINX_VERSION nginx-1.15.8

RUN apk --update add openssl-dev pcre-dev zlib-dev wget build-base && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxvf ${NGINX_VERSION}.tar.gz && \
    cd /tmp/src/${NGINX_VERSION} && \
    ./configure \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --prefix=/etc/nginx \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/local/sbin/nginx && \
    make && \
    make install && \
    apk del build-base && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

#VOLUME ["/var/log/nginx"]
#WORKDIR /etc/nginx
RUN chmod 755 /usr/local/sbin/nginx & \
    mkdir -p /var/log/konker-platform

COPY docker-resources/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker-resources/nginx/nginx.conf /etc/nginx/conf/nginx.conf
COPY docker-resources/nginx/mime.types /etc/nginx/mime.types
COPY docker-resources/nginx/conf.d /etc/nginx/conf.d
COPY docker-resources/nginx/favicon.ico /etc/nginx/html/
COPY docker-resources/nginx/filebeat /filebeat
COPY docker-resources/nginx/filebeat.yml /filebeat/filebeat.yml

RUN chmod 777 /filebeat/filebeat && \
    chmod go-w /filebeat/filebeat.yml

#start
EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD ["java","-Dconfig.file=/var/lib/konker/application.conf","-jar","/var/lib/konker/registry-api.jar"]
