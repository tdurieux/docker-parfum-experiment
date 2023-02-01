FROM node:5.10.1
MAINTAINER Stackie Jia <stackia@keylol.com>

ENV NGINX_VERSION 1.10.3-1~jessie

RUN echo "deb [trusted=yes] http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*

COPY package.json .
RUN NPM_CONFIG_LOGLEVEL=warn npm install

COPY keylol-frontend.sh /usr/local/bin/keylol-frontend
RUN chmod +x /usr/local/bin/keylol-frontend

COPY *.js ./
COPY *.ejs ./
COPY *.pdf ./
COPY src src/
COPY assets assets/

ENV BUILD_TASK prod
ENV BUILD_COPY_TARGET /usr/share/nginx/html
RUN keylol-frontend build ${BUILD_TASK}

COPY nginx-site.conf /etc/nginx/conf.d/default.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

ENV PRERENDER_AUTHORIZATION "Basic a2V5bG9sOmZvb2Jhcg=="

EXPOSE 80
CMD keylol-frontend start
