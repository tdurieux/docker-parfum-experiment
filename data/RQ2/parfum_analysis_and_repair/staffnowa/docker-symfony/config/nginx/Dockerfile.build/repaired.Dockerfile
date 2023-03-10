ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}

ARG NGINX_VERSION
ARG PROJECT_DOMAIN_1
ARG PROJECT_DOMAIN_2
ARG PROJECT_DOMAIN_3
ARG PROJECT_DOMAIN_4
ARG DOCUMENT_ROOT
ARG SYMFONY_FRONT_CONTROLLER
ARG PHP_MAX_EXECUTION_TIME
ARG PHP_UPLOAD_MAX_FILESIZE

ARG PORT_PHP

MAINTAINER Vasilij Dusko <support@d4d.lt>

RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y gnupg1 \
	&& \
	NGINX_GPGKEY=ABF5BD827BD9BF62; \
	found=''; \
	for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
		hkp://p80.pool.sks-keyservers.net:80 \
		pgp.mit.edu \
	; do \
		echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
		apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
	done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
	apt-get remove --purge -y gnupg1 && apt-get -y --purge autoremove && rm -rf /var/lib/apt/lists/* \
	&& echo "deb http://nginx.org/packages/mainline/debian/ __DEBIAN_VERSION__ nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt=${NGINX_VERSION} \
						nginx-module-geoip=${NGINX_VERSION} \
						nginx-module-image-filter=${NGINX_VERSION} \
#						nginx-module-njs=${NJS_VERSION} \
						gettext-base \
						nano \
	&& rm -rf /var/lib/apt/lists/*

COPY project.conf /etc/nginx/sites-available/
COPY rewrite/project.conf /etc/nginx/rewrite/

COPY ["d4d/cache.conf", "d4d/sf.conf", "d4d/pwa.conf", "d4d/wp.conf", "/etc/nginx/d4d/"]
__D4D_SSL__

# optional commands to run at shell inside container at build time
# this one adds package repo for nginx from nginx.org and installs it
# forward request and error logs to docker log collector

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& mkdir -p /etc/nginx/sites-available \
	&& mkdir -p /etc/nginx/sites-enabled \
	&& mkdir -p /etc/nginx/d4d \
	&& mkdir -p /etc/nginx/rewrite \
	&& sed -i 's#__PROJECT_DOMAIN_1__#'"${PROJECT_DOMAIN_1}"'#g' /etc/nginx/sites-available/project.conf \
	&& sed -i 's#__PROJECT_DOMAIN_2__#'"${PROJECT_DOMAIN_2}"'#g' /etc/nginx/sites-available/project.conf \
    && sed -i 's#__PROJECT_DOMAIN_3__#'"${PROJECT_DOMAIN_3}"'#g' /etc/nginx/sites-available/project.conf \
    && sed -i 's#__PROJECT_DOMAIN_4__#'"${PROJECT_DOMAIN_4}"'#g' /etc/nginx/sites-available/project.conf \
    && sed -i 's#__DOCUMENT_ROOT__#'"${DOCUMENT_ROOT}"'#g' /etc/nginx/sites-available/project.conf \
    && sed -i 's#__SYMFONY_FRONT_CONTROLLER__#'"${SYMFONY_FRONT_CONTROLLER}"'#g' /etc/nginx/sites-available/project.conf \
    && sed -i 's#__PHP_MAX_EXECUTION_TIME__#'"${PHP_MAX_EXECUTION_TIME}"'#g' /etc/nginx/sites-available/project.conf \
    && sed -i 's#__PHP_UPLOAD_MAX_FILESIZE__#'"${PHP_UPLOAD_MAX_FILESIZE}"'#g' /etc/nginx/sites-available/project.conf \
    && ln -s /etc/nginx/sites-available/project.conf /etc/nginx/sites-enabled/project.conf \
    && echo "upstream php-upstream { server php:${PORT_PHP}; }" > /etc/nginx/conf.d/upstream.conf

CMD ["nginx", "-g", "daemon off;"]
# required: run this command when container is launched
# only one CMD allowed, so if there are multiple, last one wins