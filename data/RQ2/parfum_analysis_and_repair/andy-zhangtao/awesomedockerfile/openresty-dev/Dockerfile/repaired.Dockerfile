FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y libreadline-dev libncurses5-dev libpcre3-dev \
    libssl-dev perl make build-essential wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://openresty.org/download/openresty-1.17.8.2.tar.gz && \
    tar -zxvf openresty-1.17.8.2.tar.gz && \
    cd /openresty-1.17.8.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && rm openresty-1.17.8.2.tar.gz

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

CMD ["/usr/local/openresty/bin/openresty","-g","daemon off;"]