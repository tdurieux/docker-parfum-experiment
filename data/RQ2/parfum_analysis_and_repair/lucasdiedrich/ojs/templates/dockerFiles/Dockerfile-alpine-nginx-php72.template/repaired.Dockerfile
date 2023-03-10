FROM php:7.2-fpm

LABEL maintainer="Public Knowledge Project <marc.bria@gmail.com>"
WORKDIR /var/www/html

ENV COMPOSER_ALLOW_SUPERUSER=1  \
    SERVERNAME="localhost"      \
    HTTPS="on"                  \
    OJS_VERSION=%%OJS_VERSION%% \
    OJS_CLI_INSTALL="0"         \
    OJS_DB_HOST="localhost"     \
    OJS_DB_USER="ojs"           \
    OJS_DB_PASSWORD="ojs"       \
    OJS_DB_NAME="ojs"           \
    OJS_WEB_CONF="/etc/nginx/conf.d/ojs.conf" \
    OJS_CONF="/var/www/html/config.inc.php"   \
    PACKAGES="supervisor dcron ttf-freefont nginx php7-cli php7-zlib php7-json       \
             php7-mbstring php7-tokenizer php7-simplexml php7-phar php7-openssl       \
             php7-curl php7-mcrypt php7-pdo_mysql php7-mysqli php7-session php7-ctype \
             php7-gd php7-xml php7-dom php7-iconv curl nodejs git openssl"            \
    EXCLUDE_URL="https://raw.githubusercontent.com/pkp/docker-ojs/master/excludeVar.list"

RUN apk add --update --no-cache $PACKAGES && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # Configure and download code from git
    git config --global url.https://.insteadOf git:// && \
    git config --global advice.detachedHead false && \
    git clone --depth 1 --single-branch --branch $OJS_VERSION --progress https://github.com/pkp/ojs.git . && \
    git submodule update --init --recursive >/dev/null && \
    # Install NPM and Composer Deps
    composer update -d lib/pkp --no-dev && \
    composer install -d plugins/paymethod/paypal --no-dev && \
    composer install -d plugins/generic/citationStyleLanguage --no-dev && \
    npm install -y && npm run build && \
    # Create directories
    mkdir -p /var/www/files /run/nginx  /run/supervisord/ /etc/ssl/nginx && \
    cp config.TEMPLATE.inc.php config.inc.php && \
    chown -R nginx:nginx /var/www/* && \
    # Prepare freefont for captcha 
	&& ln -s /usr/share/fonts/TTF/FreeSerif.ttf /usr/share/fonts/FreeSerif.ttf \
    # Prepare crontab
    echo "0 * * * *   ojs-run-scheduled" | crontab - && \
    # Clear the image
    curl "$EXCLUDE_URL" -o ./excludeVar.list && \
    source ./excludeVar.list && \
    rm -rf $EXCLUDE && \
    apk del --no-cache nodejs git && \
    find . \( -name .gitignore -o -name .gitmodules -o -name .keepme \) -exec rm '{}' \;

COPY root/ /

# Copy nginx ojs.conf
# COPY root/etc/nginx/conf.d/ojs.conf /etc/nginx/conf.d/default.conf

# Copy php configuration
# COPY root/php7/conf.d/0-ojs.ini /etc/php7/conf.d/0-ojs.ini
# COPY root/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf
# COPY root/php7/php-fpm.d/global.conf /etc/php7/php-fpm.d/global.conf

# Copy supervisor configuration
# COPY root/etc/supervisord.conf /etc/supervisord.conf

EXPOSE 80 443

VOLUME [ "/var/www/files", "/var/www/html/public" ]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]