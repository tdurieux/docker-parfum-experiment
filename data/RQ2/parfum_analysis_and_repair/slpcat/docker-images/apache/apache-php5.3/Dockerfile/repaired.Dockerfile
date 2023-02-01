FROM webdevops/php-apache:ubuntu-12.04
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US:UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    APPLICATION_USER="application" \
    APPLICATION_GROUP="application" \
    APPLICATION_PATH="/app"

COPY www_root /app

# Set timezone and locales
RUN set -x \
    && echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq apt-utils dialog locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG && rm -rf /var/lib/apt/lists/*;
    #&& DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \

# Install required packages
RUN \
    apt-get dist-upgrade -y \
    && chown -R ${APPLICATION_USER}:${APPLICATION_GROUP} ${APPLICATION_PATH} \
    && docker-image-cleanup
