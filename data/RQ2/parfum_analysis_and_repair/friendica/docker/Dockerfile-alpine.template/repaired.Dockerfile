FROM php:%%PHP_VERSION%%-%%VARIANT%%

# entrypoint.sh and cron.sh dependencies
RUN set -ex; \
    apk add --no-cache \
        rsync \
# For mail() support
        msmtp \
        shadow \
        tini;

ENV GOSU_VERSION 1.14
RUN set -eux; \
	\
	apk add --no-cache --virtual .gosu-deps \
		ca-certificates \
		dpkg \
		gnupg \
	; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
# clean up fetch dependencies
	apk del --no-network .gosu-deps; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu --version; \
	gosu nobody true

# install the PHP extensions we need
# see https://friendi.ca/resources/requirements/
RUN set -ex; \

    apk add --no-cache --virtual .build-deps \
        mariadb-client \
        bash \
        $PHPIZE_DEPS \
        libpng-dev \
        libjpeg-turbo-dev \
        imagemagick-dev \
        libtool \
        libmemcached-dev \
        cyrus-sasl-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libwebp-dev \
        librsvg \
        pcre-dev \
        libzip-dev \
        icu-dev \
        openldap-dev \
    ; \

    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    ; \

    docker-php-ext-install -j "$(nproc)" \
        pdo_mysql \
        exif \
        gd \
        zip \
        opcache \
        pcntl \
        ldap \
    ; \

# pecl will claim success even if one install fails, so we need to perform each install separately
    pecl install APCu-%%APCU_VERSION%%; \
    pecl install memcached-%%MEMCACHED_VERSION%%; \
    pecl install redis-%%REDIS_VERSION%%; \
    pecl install imagick-%%IMAGICK_VERSION%%; \

    docker-php-ext-enable \
        apcu \
        memcached \
        redis \
        imagick \
    ; \

    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-cache --no-network --virtual .friendica-phpext-rundeps $runDeps; \
    apk del --no-network .build-deps;

# set recommended PHP.ini settings
ENV PHP_MEMORY_LIMIT 512M
ENV PHP_UPLOAD_LIMIT 512M
RUN set -ex; \
    { \
        echo 'opcache.enable=1' ; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidte_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
    \
    { \
        echo sendmail_path = "/usr/bin/msmtp -t"; \
    } > /usr/local/etc/php/conf.d/sendmail.ini; \
    \
    echo 'apc.enable_cli=1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini; \
    \
    { \
        echo 'memory_limit=${PHP_MEMORY_LIMIT}'; \
        echo 'upload_max_filesize=${PHP_UPLOAD_LIMIT}'; \
        echo 'post_max_size=${PHP_UPLOAD_LIMIT}'; \
    } > /usr/local/etc/php/conf.d/friendica.ini; \
    \
    mkdir /var/www/data; \
    chown -R www-data:root /var/www; \
    chmod -R g=u /var/www

VOLUME /var/www/html
%%VARIANT_EXTRAS%%

# 39 = LOG_PID | LOG_ODELAY | LOG_CONS | LOG_PERROR
ENV FRIENDICA_SYSLOG_FLAGS 39
ENV FRIENDICA_VERSION "%%VERSION%%"
ENV FRIENDICA_ADDONS "%%VERSION%%"
%%DOWNLOAD_SHA256%%
%%INSTALL_EXTRAS%%
COPY *.sh upgrade.exclude /
COPY config/* /usr/src/friendica/config/

ENTRYPOINT ["/%%ENTRYPOINT%%"]
CMD ["%%CMD%%"]
