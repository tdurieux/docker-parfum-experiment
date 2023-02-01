FROM appsvcorg/nginx-fpm:php7.2.13
LABEL maintainer ="Azure App Service Container Images <appsvc-images@microsoft.com>"
# ========
# ENV vars
# ========
#
ENV DOCKER_BUILD_HOME "/dockerbuild"
# drupal 
ENV DRUPAL_HOME "/home/site/wwwroot"
ENV DRUPAL_PRJ "/home/drupal_prj"
# mariadb
ENV MARIADB_DATA_DIR "/home/data/mysql"
ENV MARIADB_LOG_DIR "/home/LogFiles/mysql"
# phpmyadmin
ENV PHPMYADMIN_SOURCE "/usr/src/phpmyadmin"
ENV PHPMYADMIN_HOME "/home/phpmyadmin"
# drupal
ENV DRUPAL_SOURCE "/usr/src/drupal"
#nginx
ENV NGINX_LOG_DIR "/home/LogFiles/nginx"
#varnish
ENV VARNISH_LOG_DIR "/home/LogFiles/varnish"
#php
ENV PHP_CONF_FILE "/usr/local/etc/php/php.ini"
# Composer
# Updation: https://getcomposer.org/download/
ENV COMPOSER_DOWNLOAD_URL "https://getcomposer.org/installer"
# ====================
# Download and Install
# ~. essentials
# 1. Drupal
# ====================
RUN mkdir -p $DOCKER_BUILD_HOME
WORKDIR $DOCKER_BUILD_HOME
RUN set -ex \
# --------
# ~. essentials
# --------
# ~. PHP extensions
# --------
# install the PHP extensions we need
# postgresql-dev is needed for https://bugs.alpinelinux.org/issues/3642
    && docker-php-source extract \
    && apk add --no-cache                  \
            --virtual .build-dependencies   \
                $PHPIZE_DEPS                \
                zlib-dev                    \
                cyrus-sasl-dev              \
                git                         \
                autoconf                    \
                build-base                  \ 
                g++                         \
                libtool                     \
                make                        \
                pcre-dev                    \    
            tini                            \
            libintl                         \
            icu                             \
            icu-dev                         \
            libxml2-dev                     \
            postgresql-dev                  \
            freetype-dev                    \
            libjpeg-turbo-dev               \
            libpng-dev                      \
            gmp                             \
            gmp-dev                         \
            libmemcached-dev                \
            imagemagick-dev                 \
            libssh2                         \
            libssh2-dev                     \
            libxslt-dev                     \
            ruby-dev                        \
            gnupg                           \	                  
    && echo 'Installing redis PHP extension...' \
    && pecl install redis-4.2.0 \
    && docker-php-ext-enable redis \
    &&  echo 'Configuring gd PHP extension...' \
	&& docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
		--with-png-dir=/usr/include/ \
    && echo 'Installing gd & zip PHP extensions...' \
	&& docker-php-ext-install -j "$(nproc)" \
		gd \		
		zip \		
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --virtual .drupal-phpexts-rundeps $runDeps \	
	&& docker-php-source delete \
    # session_save_path
    && mkdir -p /usr/local/php/tmp \
    && chmod 777 /usr/local/php/tmp \
# -------------
# 1. Drupal
# -------------
    && mkdir -p ${DRUPAL_SOURCE}\
# ----------
# 2. composer
# ----------
	&& curl -sS $COMPOSER_DOWNLOAD_URL | php -- --install-dir=/usr/bin --filename=composer \
	&& composer self-update \
# ----------
# 3. drush
# ----------
    && rm -rf /home/.composer && export COMPOSER_HOME='/root/.composer/' \
    && composer global require consolidation/cgr \
	&& composer_home=$(find / -name .composer) \
    && ln -s $composer_home/vendor/bin/cgr /usr/local/bin/cgr \
	&& cgr drush/drush \
    && ln -s $composer_home/vendor/bin/drush /usr/local/bin/drush \
# ----------
# 4. varnish
# ----------
    && apk update \
    && apk add --no-cache varnish\
    && rm -rf /var/log/varnish \
	&& ln -s $VARNISH_LOG_DIR /var/log/varnish \
# ----------
# 5. fluent-plugin-azure-loganalytics
# ----------
    && echo 'Installing fluent-plugin-azure-lognalaytics (and dependencies)...' \
    && apk add --no-cache ruby ruby-irb ruby-etc ruby-webrick imagemagick \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && gem install oj:3.3.10 \ 
                json:2.1.0 \
                fluentd:1.3.2 \ 
                bigdecimal:1.3.5 \
    && gem install fluent-plugin-azure-loganalytics \
# ----------
# ~. clean up
# ----------
    && apk del .build-dependencies \	
	&& apk upgrade \
	&& rm -rf /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem /usr/src/ruby
# =========
# Configure
# =========
WORKDIR $DRUPAL_HOME
RUN rm -rf $DOCKER_BUILD_HOME
# mariadb
COPY my.cnf /etc/mysql/
# nginx
COPY spec-settings.conf /etc/nginx/conf.d/
COPY mime-font.types /etc/nginx
COPY nginx.conf /etc/nginx/
RUN rm -rf /etc/nginx/conf.d/default.conf
# php
COPY php.ini $PHP_CONF_FILE
# drupal
COPY drupal-database-install-tasks.php ${DRUPAL_SOURCE}
# phpmyadmin
COPY phpmyadmin_src/. $PHPMYADMIN_SOURCE/
# Varinish
COPY default.vcl /etc/varnish/default.vcl
# fluent-plugin-azure-loganalytics
COPY fluent.conf /etc/
# =====
# final
# =====
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 2222 80
ENTRYPOINT ["entrypoint.sh"]
