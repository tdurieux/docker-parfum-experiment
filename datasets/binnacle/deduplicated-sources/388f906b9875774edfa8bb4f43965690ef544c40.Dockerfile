FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/apache/conf /opt/bitnami/apache/tmp /opt/bitnami/apache/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.39-0 --checksum 203e0194423a966fed02042958475489aaac537faf92cbc02ddb67b6edb257b3
RUN bitnami-pkg unpack php-7.2.17-0 --checksum 56ee63e0e176180f76c4bc1ffa6f1aa379d8cfb2991f9c4dedeb74ccbe62c92f
RUN bitnami-pkg install wp-cli-2.1.0-0 --checksum 054d17c151d0b4b4fbb119eac077889f090c3572b3fe8e44584ff4ffb5e15a54
RUN bitnami-pkg unpack mysql-client-10.1.38-0 --checksum fdd44abc2ff752b759ded1a7f27e334feed2be427a5850e2d21f2d093f3fee75
RUN bitnami-pkg unpack libphp-7.2.17-0 --checksum 073b20163ea8f9d0b4cfc8676e97e9d718dc14c16cf7ef1ebcc30e7ba1463a90
RUN bitnami-pkg unpack wordpress-5.1.1-6 --checksum 7718babbac1dec09dee4127b3aa7ab4ec715acce64ea8ff92656774e7d09630c
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="8443" \
    APACHE_HTTP_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="wordpress" \
    BITNAMI_IMAGE_VERSION="5.1.1-rhel-7-r40" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/wp-cli/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER="" \
    SMTP_USERNAME="" \
    WORDPRESS_BLOG_NAME="User's Blog!" \
    WORDPRESS_DATABASE_NAME="bitnami_wordpress" \
    WORDPRESS_DATABASE_PASSWORD="" \
    WORDPRESS_DATABASE_USER="bn_wordpress" \
    WORDPRESS_EMAIL="user@example.com" \
    WORDPRESS_FIRST_NAME="FirstName" \
    WORDPRESS_HOST="" \
    WORDPRESS_HTACCESS_OVERRIDE_NONE="yes" \
    WORDPRESS_HTTPS_PORT="8443" \
    WORDPRESS_HTTP_PORT="8080" \
    WORDPRESS_LAST_NAME="LastName" \
    WORDPRESS_PASSWORD="bitnami" \
    WORDPRESS_SKIP_INSTALL="no" \
    WORDPRESS_TABLE_PREFIX="wp_" \
    WORDPRESS_USERNAME="user"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
