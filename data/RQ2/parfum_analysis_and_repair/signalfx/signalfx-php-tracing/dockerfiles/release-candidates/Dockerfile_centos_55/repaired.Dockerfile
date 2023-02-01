FROM cytopia/php-fpm-5.5

RUN set -xe; \
  yum install -y yum-utils git curl libcurl-devel; rm -rf /var/cache/yum

# Install ddtrace
ARG ddtracePkgUrl
RUN set -eux; \
    cd ${HOME}; \
    curl -f -L "${ddtracePkgUrl}" -o ./ddtrace.rpm; \
    rpm -ivh ddtrace.rpm;
