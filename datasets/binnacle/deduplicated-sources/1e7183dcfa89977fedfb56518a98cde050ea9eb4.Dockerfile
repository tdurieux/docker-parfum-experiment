FROM phalconphp/build:ubuntu-bionic

LABEL description="Docker images to build Phalcon on Ubuntu 18.04" \
    maintainer="Serghei Iakovlev <serghei@phalconphp.com>" \
    vendor=Phalcon \
    name="com.phalconphp.images.build.bionic-7.2"

RUN apt purge -y \
        php7.0-common \
        php7.0-dev \
        php7.0-json \
    && apt clean -y \
    && apt update -y \
    && apt upgrade -y \
    && apt install --no-install-recommends -yq \
        php7.2-common \
        php7.2-dev \
        php7.2-cli \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /tmp/* /var/tmp/* /etc/php/7.0 \
    && find /var/cache/apt/archives /var/lib/apt/lists -not -name lock -type f -delete \
    && find /var/cache -type f -delete \
    && find /var/log -type f | while read f; do echo -n '' > ${f}; done
