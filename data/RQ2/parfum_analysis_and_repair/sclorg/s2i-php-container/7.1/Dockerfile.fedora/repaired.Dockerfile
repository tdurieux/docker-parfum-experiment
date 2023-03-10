FROM registry.fedoraproject.org/f27/s2i-base:latest

# This image provides an Apache+PHP environment for running PHP
# applications.

EXPOSE 8080
EXPOSE 8443

ENV PHP_VERSION=7.1 \
    PATH=$PATH:/usr/bin

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

ENV NAME=php \
    VERSION=0 \
    RELEASE=1 \
    ARCH=x86_64

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Apache 2.4 with PHP 7.1" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,php,php71,rh-php71" \
      name="$FGC/$NAME" \
      com.redhat.component="$NAME" \
      version="$VERSION" \
      usage="s2i build https://github.com/sclorg/s2i-php-container.git --context-dir=/7.1/test/test-app $FGC/$NAME sample-server" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# Install Apache httpd and PHP
RUN INSTALL_PKGS="php php-mysqlnd php-bcmath \
                  php-gd php-intl php-ldap php-mbstring php-pdo \
                  php-process php-soap php-opcache php-xml \
                  php-gmp php-pecl-apcu mod_ssl hostname" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --nogpgcheck && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

ENV PHP_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/php/ \
    APP_DATA=${APP_ROOT}/src \
    PHP_DEFAULT_INCLUDE_PATH=/usr/share/pear \
    PHP_SYSCONF_PATH=/etc/ \
    PHP_HTTPD_CONF_FILE=php.conf \
    HTTPD_CONFIGURATION_PATH=${APP_ROOT}/etc/conf.d \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/var/www \
    HTTPD_VAR_PATH=/var

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# Reset permissions of filesystem to default values
# Generate SSL certs and reset permissions of filesystem to default values
RUN /usr/libexec/httpd-ssl-gencerts && \
    /usr/libexec/container-setup && rpm-file-permissions

# Fedora uses by default 'event' MPM module
# switch to 'prefork' to provide same user experience as with RHEL image
# Code taken from 'config_mpm()' function in sclorg/httpd-container repo
ENV HTTPD_MPM=prefork \
    HTTPD_MAIN_CONF_MODULES_D_PATH=/etc/httpd/conf.modules.d

RUN if [ -v HTTPD_MPM -a -f ${HTTPD_MAIN_CONF_MODULES_D_PATH}/00-mpm.conf ]; then \
    mpmconf=${HTTPD_MAIN_CONF_MODULES_D_PATH}/00-mpm.conf; \
    sed -i -e 's,^LoadModule,#LoadModule,' ${mpmconf}; \
    sed -i -e "/LoadModule mpm_${HTTPD_MPM}/s,^#LoadModule,LoadModule," ${mpmconf}; \
    echo "---> Set MPM to ${HTTPD_MPM} in ${mpmconf}"; \
  fi

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
