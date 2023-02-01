FROM ubuntu:latest
LABEL maintainer="Kenichi Nakamura <kenichi.nakamura@gmail.com>"

RUN apt update && \
    apt install --no-install-recommends -y build-essential libpcre3 libpcre3-dev zlib1g-dev curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src
RUN curl -f -O https://www.openssl.org/source/openssl-1.0.2o.tar.gz && \
    curl -f -O https://nginx.org/download/nginx-1.14.0.tar.gz && \
    tar xf openssl-1.0.2o.tar.gz && \
    tar xf nginx-1.14.0.tar.gz && rm openssl-1.0.2o.tar.gz

RUN cd nginx-1.14.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-http_v2_module \
                --with-http_ssl_module \
                --with-openssl=../openssl-1.0.2o && \
    make install

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

RUN touch /usr/local/nginx/logs/access.log && \
    ln -sf /dev/stdout /usr/local/nginx/logs/access.log && \
    touch /usr/local/nginx/logs/error.log && \
    ln -sf /dev/stderr /usr/local/nginx/logs/error.log

WORKDIR /usr/local/nginx
EXPOSE 443
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
