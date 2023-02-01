FROM miveo/centos-php-fpm:7.2-no-xdebug

# Install ddtrace
ARG ddtracePkgUrl
RUN set -eux; \
    cd ${HOME}; \
    curl -f -L "${ddtracePkgUrl}" -o ./ddtrace.rpm; \
    rpm -ivh ddtrace.rpm;
