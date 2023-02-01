FROM buildpack-deps:xenial

ENV NGINX_VERSION 1.19.9
ENV OPENSSL_VERSION 1.1.1l
ENV YAML_VERSION 0.2.1
ENV NGX_VTS_REV 46d85558e344dfe2b078ce757fd36c69a1ec2dd3
ENV NGX_MRUBY_REV 76a55dad0528862ec5ad34c76fb4d19c17217358

RUN apt -y update && apt -y --no-install-recommends install build-essential bison libpcre3-dev libpcre++-dev debhelper \
                   flex gcc make automake autoconf libtool git libreadline6-dev \
                   zlib1g-dev libncurses5-dev libssl-dev rake libpam0g-dev \
                   autotools-dev cgroup-lite git && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth=100 https://github.com/vozlt/nginx-module-vts && \
    cd nginx-module-vts && git checkout $NGX_VTS_REV
RUN git clone --depth=100 https://github.com/matsumotory/ngx_mruby && \
    cd ngx_mruby && git checkout $NGX_MRUBY_REV
RUN wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz && \
    tar zxf openssl-$OPENSSL_VERSION.tar.gz && rm openssl-$OPENSSL_VERSION.tar.gz
RUN wget https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    tar zxf nginx-$NGINX_VERSION.tar.gz && rm nginx-$NGINX_VERSION.tar.gz
RUN wget https://pyyaml.org/download/libyaml/yaml-$YAML_VERSION.tar.gz && \
    tar zxf yaml-$YAML_VERSION.tar.gz && \
    cd yaml-$YAML_VERSION && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm yaml-$YAML_VERSION.tar.gz

ADD build_config.rb /ngx_mruby/build_config.rb
ADD entry.sh /entry.sh
RUN chmod +x /entry.sh

CMD ["/entry.sh"]
