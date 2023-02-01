FROM  openresty/openresty:1.11.2.5-alpine-fat
RUN apk update && \
      apk add --no-cache -y unzip make gcc git curl openssl openssl-dev && \
      wget https://github.com/luarocks/luarocks/archive/2.4.3.tar.gz && \
      tar -zxvf 2.4.3.tar.gz && \
      cd /luarocks-2.4.3 && \
      ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --lua-suffix=jit --with-lua=/usr/local/openresty/luajit --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
      make build && \
      make install && rm 2.4.3.tar.gz
RUN   cd / && \
      git clone https://github.com/Kong/kong.git && \
      cd kong && \
      git checkout 0.12.0 && \
      make install
