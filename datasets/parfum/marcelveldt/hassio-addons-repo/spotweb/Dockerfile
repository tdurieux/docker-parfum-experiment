ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Environment variables
ENV APP_ID="spotweb"
ENV APP_NAME="Spotweb"
ENV APP_DIR="/app"
ENV SPOTWEB_RELEASE="1.4.5"

# Install app dependencies
RUN apk -U update && \
    apk -U add --no-cache \
        tar \
        wget \
        nginx \
        php7 \
        php7-fpm \
        php7-curl \
        php7-dom \
        php7-gettext \
        php7-xml \
        php7-simplexml \
        php7-zip \
        php7-zlib \
        php7-gd \
        php7-openssl \
        php7-mysqli \
        php7-pdo \
        php7-pdo_mysql \
        php7-json \
        php7-mbstring \
        php7-ctype \
        php7-opcache \
        php7-session \
        mysql-client \
    # Install latest Spotweb release
    && mkdir -p /app \
    && cd /tmp \
    && wget -c "https://github.com/spotweb/spotweb/archive/$SPOTWEB_RELEASE.tar.gz" \
    && tar -zxf /tmp/$SPOTWEB_RELEASE.tar.gz \
    && cp -a /tmp/spotweb-$SPOTWEB_RELEASE/. /app/ \
    && rm -R /tmp/spotweb-$SPOTWEB_RELEASE/ \
    && rm /tmp/$SPOTWEB_RELEASE.tar.gz \
    # spotweb needs a timezone set in the php.ini
    # TODO: Can we dynamically set the correct timezone here ?
    && sed -i "s/;date.timezone =/date.timezone = \"Europe\/Amsterdam\"/g" /etc/php7/php.ini

# Copy rootfs
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${APP_NAME}" \
    io.hass.description="${APP_NAME} Add-on for Home Assistant" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Marcel van der Veldt @marcelveldt <m.vanderveldt@outlook.com>" \
    org.label-schema.description="${APP_NAME} Add-on for Home Assistant" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="${APP_NAME}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/marcelveldt/hassio-addons-repo/${APP_ID}" \
    org.label-schema.usage="https://github.com/marcelveldt/hassio-addons-repo/tree/master/${APP_ID}/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/marcelveldt/hassio-addons-repo/${APP_ID}" \
    org.label-schema.vendor="Marcelveldt's Community Add-ons for Home Assistant"