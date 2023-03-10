FROM amazonlinux:1

# Install php
RUN set -eux; \
    yum update -y; \
    yum install -y \
        gcc make libcurl-devel vim \
        php55 php55-devel php55-common php55-fpm php55-cli \
        php55-pecl-apc php55-pdo php55-xml php55-opcache \
        php55-gd php55-mbstring php-pear php55-mysqlnd php55-mcrypt; rm -rf /var/cache/yum

RUN set -eux; \
    # Allow any IP address to listen to PHP-FPM
    sed -e '/listen\.allowed_clients/d' \
        -e 's/listen = .*/listen = 9000/g' \
    # Catch worker output
        -e 's/;catch_workers_output = .*/catch_workers_output = yes/g' \
    # Send error log to proper place
        -e 's/php_admin_value\[error_log\].*/php_admin_value[error_log] = \/proc\/self\/fd\/2/g' \
    # Don't clear the env
        -e 's/;clear_env = .*/clear_env = no/g' \
    # This line generates errors (no ext/soap) so delete it \
        -e '/php_value\[soap\.wsdl_cache_dir\].*/d' \
        -i /etc/php-fpm.d/www.conf; \
    # Send error log to proper place
    sed -e 's/error_log = .*/error_log = \/proc\/self\/fd\/2/g' -i /etc/php-fpm.conf;

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
