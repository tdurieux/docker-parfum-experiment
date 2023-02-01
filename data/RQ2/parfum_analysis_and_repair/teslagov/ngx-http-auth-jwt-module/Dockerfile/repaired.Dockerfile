ARG NGINX_VERSION=1.22.0


FROM debian:bullseye-slim as BASE_IMAGE
LABEL stage=builder
RUN apt-get update \
	&& apt-get install --no-install-recommends -y curl build-essential && rm -rf /var/lib/apt/lists/*;


FROM BASE_IMAGE as BUILD_IMAGE
LABEL stage=builder
ENV LD_LIBRARY_PATH=/usr/local/lib
ARG NGINX_VERSION
ADD . /root/dl/ngx-http-auth-jwt-module
RUN set -x \
	&& apt-get install --no-install-recommends -y libjwt-dev libjwt0 libjansson-dev libjansson4 libpcre2-dev zlib1g-dev libpcre3-dev \
	&& mkdir -p /root/dl && rm -rf /var/lib/apt/lists/*;
WORKDIR /root/dl
RUN set -x \
	&& curl -f -O http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
	&& tar -xzf nginx-$NGINX_VERSION.tar.gz \
	&& rm nginx-$NGINX_VERSION.tar.gz \
	&& ln -sf nginx-$NGINX_VERSION nginx \
	&& cd /root/dl/nginx \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-compat --add-dynamic-module=../ngx-http-auth-jwt-module \
	&& make modules


FROM nginx:${NGINX_VERSION}
LABEL stage=builder
RUN apt-get update \
    && apt-get -y --no-install-recommends install libjansson4 libjwt0 \
	&& cd /etc/nginx \
	&& cp nginx.conf nginx.conf.orig \
	&& sed -ri '/pid\s+\/var\/run\/nginx\.pid;$/a load_module \/usr\/lib64\/nginx\/modules\/ngx_http_auth_jwt_module\.so;' nginx.conf && rm -rf /var/lib/apt/lists/*;


LABEL stage=
LABEL maintainer="TeslaGov" email="developers@teslagov.com"
COPY --from=BUILD_IMAGE /root/dl/nginx/objs/ngx_http_auth_jwt_module.so /usr/lib64/nginx/modules/
