#TAGS 1.12.2 stable 1.12
FROM laincloud/debian:stretch

LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"

ENV NGINX_VERSION 1.12.2-1~stretch
ENV NJS_VERSION   1.12.2.0.1.14-1~stretch

RUN set -x \
	&& apt-get -qq -y update \
	&& apt-get -qq -y --no-install-recommends --no-install-suggests install gnupg1 apt-transport-https ca-certificates \
	&& \
	NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
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
	apt-get -qq -y --purge --auto-remove remove gnupg1 && rm -rf /var/lib/apt/lists/* \
	&& dpkgArch="$(dpkg --print-architecture)" \
	&& nginxPackages=" \
		nginx=${NGINX_VERSION} \
		nginx-module-xslt=${NGINX_VERSION} \
		nginx-module-geoip=${NGINX_VERSION} \
		nginx-module-image-filter=${NGINX_VERSION} \
		nginx-module-njs=${NJS_VERSION} \
	" \
	&& case "$dpkgArch" in \
		amd64|i386) \
# arches officialy built by upstream
			echo "deb https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
			&& apt-get -qq -y update \
			;; \
		*) \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published source packages
			echo "deb-src https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
			\
# new directory for storing sources and .deb files
			&& tempDir="$(mktemp -d)" \
			&& chmod 777 "$tempDir" \
# (777 to ensure APT's "_apt" user can access it too)
			\
# save list of currently-installed packages so build dependencies can be cleanly removed later
			&& savedAptMark="$(apt-mark showmanual)" \
			\
# build .deb files from upstream's source packages (which are verified by apt-get)
			&& apt-get -qq -y update \
			&& apt-get -qq -y build-dep $nginxPackages \
			&& ( \
				cd "$tempDir" \
				&& DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)" \
					apt-get -qq -y --compile source $nginxPackages \
			) \
# we don't remove APT lists here because they get re-downloaded and removed later
			\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
# (which is done after we install the built packages so we don't have to redownload any overlapping dependencies)
			&& apt-mark showmanual | xargs apt-mark auto > /dev/null \
			&& { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; } \
			\
# create a temporary local APT repo to install from (so that dependency resolution can be handled by APT, as it should be)
			&& ls -lAFh "$tempDir" \
			&& ( cd "$tempDir" && dpkg-scanpackages . > Packages ) \
			&& grep '^Package: ' "$tempDir/Packages" \
			&& echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list \
# work around the following APT issue by using "Acquire::GzipIndexes=false" (overriding "/etc/apt/apt.conf.d/docker-gzip-indexes")
#   Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
#   ...
#   E: Failed to fetch store:/var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages  Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
			&& apt-get -qq -y -o Acquire::GzipIndexes=false update \
			;; \
	esac \
	\
	&& apt-get -qq -y --no-install-recommends --no-install-suggests install \
						$nginxPackages \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
	\
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
	&& if [ -n "$tempDir" ]; then \
		apt-get -qq -y --auto-remove purge \
		&& rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
	fi

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]