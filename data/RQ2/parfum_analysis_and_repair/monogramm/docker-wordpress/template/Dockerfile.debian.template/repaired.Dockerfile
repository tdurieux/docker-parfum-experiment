FROM wordpress:%%VERSION%%-php%%PHP_VERSION%%-%%VARIANT%%

LABEL maintainer="Monogramm maintainers <opensource at monogramm dot io>"

# Install needed libraries
# Install needed php extensions
# Variant extras
# Edit permissions of web directories
RUN set -ex; \

	apt-get update; \
	apt-get install --no-install-recommends -y \
		bzip2 \
		csstidy \
		tidy \
		unzip \
		zip \
	; \
	mkdir -p /usr/src/php/ext; rm -rf /usr/src/php/ext \
	apt-get install --no-install-recommends -y \
		default-mysql-client \
		less \
		libcurl4-openssl-dev \
		libfreetype6-dev \
		libicu-dev \
		libjpeg-dev \
		libldap2-dev \
		libmemcached-dev \
		libonig-dev \
		libpng-dev \
		libpq-dev \
		libxml2-dev \
		libz-dev \
		libzip-dev \
	; \
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
	docker-php-ext-configure gd; \
	docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
	docker-php-ext-install -j "$(nproc)" \
		exif \
		gd \
		intl \
		ldap \
		mbstring \
		mysqli \
		opcache \
		pcntl \
		pdo_mysql \
		soap \
		zip \
	; \
	pecl install \
		apcu-%%APCU_VERSION%% \
		memcached-%%MEMCACHED_VERSION%% \
	; \
	docker-php-ext-enable \
		apcu \
		memcached \
	; \
	%%VARIANT_EXTRAS%% \
	chown www-data:www-data /var/www /var/www/html; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*


# https://make.wordpress.org/cli/2018/05/31/gpg-signature-change/
# pub   rsa2048 2018-05-31 [SC]
#	   63AF 7AA1 5067 C056 16FD  DD88 A3A2 E8F2 26F0 BC06
# uid		   [ unknown] WP-CLI Releases <releases@wp-cli.org>
# sub   rsa2048 2018-05-31 [E]
ENV WORDPRESS_CLI_GPG_KEY 63AF7AA15067C05616FDDD88A3A2E8F226F0BC06

ARG WORDPRESS_CLI_VERSION=%%WORDPRESS_CLI_VERSION%%
ARG WORDPRESS_CLI_SHA512=%%WORDPRESS_CLI_SHA512%%

WORKDIR /var/www/html

# Install wp-cli dependencies
# Cleanup
RUN set -ex; \

	apt-get update; \
	apt-get install --no-install-recommends -y \
		dirmngr \
		gnupg \
	; \

	curl -o /usr/local/bin/wp.gpg -fSL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar.gpg"; \

	export GNUPGHOME="$(mktemp -d)"; \
	for server in $(shuf -e ha.pool.sks-keyservers.net \
							hkp://p80.pool.sks-keyservers.net:80 \
							keyserver.ubuntu.com \
							hkp://keyserver.ubuntu.com:80 \
							pgp.mit.edu); do \

		gpg --batch --keyserver "$server" --recv-keys "$WORDPRESS_CLI_GPG_KEY" && break || :; \
	done \
	; \
	gpg --batch --decrypt --output /usr/local/bin/wp /usr/local/bin/wp.gpg; \
	rm -rf "$GNUPGHOME" /usr/local/bin/wp.gpg; \

	echo "$WORDPRESS_CLI_SHA512 */usr/local/bin/wp" | sha512sum -c -; \
	chmod +x /usr/local/bin/wp; \

	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \

	wp --allow-root --version

# ENTRYPOINT resets CMD
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["%%CMD%%"]
