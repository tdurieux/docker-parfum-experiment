FROM openresty/openresty:xenial

RUN apt-get update \
    && apt-get install -y \
       git \
    && mkdir /src \
    && cd /src \
    && git config --global url."https://".insteadOf git:// \
    && luarocks install lua-resty-redis \
    && luarocks install lua-resty-lock \
    && git clone https://github.com/steve0511/resty-redis-cluster.git \
    && cd resty-redis-cluster/ \
    && luarocks make \
    && gcc -fPIC -shared -I/usr/local/openresty/luajit -o /usr/local/openresty/luajit/lib/lua/5.1/redis_slot.so lib/redis_slot.c \
    && rm -Rf /src
