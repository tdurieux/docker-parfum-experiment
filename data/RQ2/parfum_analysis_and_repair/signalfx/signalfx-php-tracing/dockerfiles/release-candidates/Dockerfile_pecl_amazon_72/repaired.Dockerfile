FROM amazonlinux:2.0.20200602.0-with-sources

# Install php
RUN set -eux; \
    amazon-linux-extras install php7.2; \
    yum install -y php-opcache php-pear php-devel gcc make libcurl-devel; rm -rf /var/cache/yum

# Configure PHP-FPM
RUN set -eux; \
    mkdir -p /run/php-fpm; \
    # Allow any IP address to listen to PHP-FPM & don't clear the env \
    sed -e '/listen\.allowed_clients/d' -e 's/listen = .*/listen = 9000/g' -e 's/;clear_env = .*/clear_env = no/g' -i /etc/php-fpm.d/www.conf; \
    # This line generates errors (no ext/soap) so delete it \
    sed -e '/php_value\[soap\.wsdl_cache_dir\].*/d' -i /etc/php-fpm.d/www.conf; \
    # Catch worker output and send error log to proper place \
    sed -e 's/php_admin_value\[error_log\].*/php_admin_value[error_log] = \/proc\/self\/fd\/2/g' -e 's/;catch_workers_output = .*/catch_workers_output = yes/g' -i /etc/php-fpm.d/www.conf; \
    sed -e 's/error_log = .*/error_log = \/proc\/self\/fd\/2/g' -i /etc/php-fpm.conf

# Install Composer
RUN set -eux; \
    curl -f -q https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer | php -- php -- --filename=composer --install-dir=/usr/local/bin

# Install ddtrace
ARG ddtracePkgUrl
RUN set -eux; \
    cd ${HOME}; \
    curl -f -L "${ddtracePkgUrl}" -o ./signalfx_tracing.tgz; \
    pecl install signalfx_tracing.tgz; \
    echo "extension=signalfx-tracing.so" > /etc/php.d/signalfx-tracing.ini

# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
STOPSIGNAL SIGQUIT

EXPOSE 9000

CMD ["php-fpm", "-F"]
