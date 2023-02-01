FROM debian:9
ARG NGINX_VERSION=
ARG NGX_MRUBY_VERSION=

RUN apt-get -qq update && apt-get -qq install -y git build-essential devscripts ruby rake bison libssl-dev wget libxslt-dev libgd-dev libgeoip-dev libperl-dev

RUN wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN echo 'deb http://nginx.org/packages/mainline/debian/ stretch nginx' >> /etc/apt/sources.list
RUN echo 'deb-src http://nginx.org/packages/mainline/debian/ stretch nginx' >> /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qq dist-upgrade -y

WORKDIR /usr/local/src
RUN apt-get -qq build-dep -y nginx="$NGINX_VERSION"
RUN apt-get -qq source nginx="$NGINX_VERSION"

RUN git clone --branch v$NGX_MRUBY_VERSION --depth 1 https://github.com/matsumoto-r/ngx_mruby.git

WORKDIR /usr/local/src/ngx_mruby
RUN ./configure --with-ngx-src-root=/usr/local/src/nginx-$NGINX_VERSION
ADD ngx_mruby/build_config.rb /usr/local/src/ngx_mruby/build_config.rb
RUN make build_mruby
RUN make generate_gems_config

WORKDIR /usr/local/src/nginx-$NGINX_VERSION
ADD ngx_mruby/debian9/rules.patch /tmp/rules.patch
RUN patch -p0 < /tmp/rules.patch
RUN dpkg-buildpackage -r -uc -b
