FROM openshift/base-centos7

# This image provides an Apache+PHP environment for running PHP
# applications.

MAINTAINER SoftwareCollections.org <sclorg@redhat.com>

EXPOSE 8080

ENV PHP_VERSION=5.5 \
    PATH=$PATH:/opt/rh/php55/root/usr/bin

LABEL io.k8s.description="Platform for building and running PHP 5.5 applications" \
      io.k8s.display-name="Apache 2.4 with PHP 5.5" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,php,php55"

# Install Apache httpd and PHP
RUN yum install -y \
    https://www.softwarecollections.org/en/scls/rhscl/httpd24/epel-7-x86_64/download/rhscl-httpd24-epel-7-x86_64.noarch.rpm \
    https://www.softwarecollections.org/en/scls/rhscl/php55/epel-7-x86_64/download/rhscl-php55-epel-7-x86_64.noarch.rpm \
    https://www.softwarecollections.org/en/scls/remi/php55more/epel-7-x86_64/download/remi-php55more-epel-7-x86_64.noarch.rpm && \
    yum install -y --setopt=tsflags=nodocs httpd24 php55 php55-php php55-php-mysqlnd php55-php-pgsql php55-php-bcmath php55-php-devel \
    php55-php-fpm php55-php-gd php55-php-intl php55-php-ldap php55-php-mbstring php55-php-pdo \
    php55-php-pecl-memcache php55-php-process php55-php-soap php55-php-opcache php55-php-xml \
    php55-php-pecl-imagick php55-php-pecl-xdebug && \
    yum clean all -y && rm -rf /var/cache/yum

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container under
# random UID.
RUN sed -i -f /opt/app-root/etc/httpdconf.sed /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    sed -i '/php_value session.save_path/d' /opt/rh/httpd24/root/etc/httpd/conf.d/php55-php.conf && \
    head -n151 /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf | tail -n1 | grep "AllowOverride All" || exit && \
    mkdir /tmp/sessions && \
    chmod -R a+rwx /opt/rh/php55/root/etc && \
    chmod -R a+rwx /opt/rh/httpd24/root/var/run/httpd && \
    chmod -R a+rwx /tmp/sessions && \
    chown -R 1001:0 /opt/app-root /tmp/sessions

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
