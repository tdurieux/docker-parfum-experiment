#
# Dockerfile for WordPress
#
FROM appsvcorg/alpine-php-mysql:0.31
MAINTAINER Azure App Service Container Images <appsvc-images@microsoft.com>

# ========
# ENV vars
# ========
# wordpress
ENV WORDPRESS_SOURCE "/usr/src/wordpress"
ENV WORDPRESS_HOME "/home/site/wwwroot"
#
ENV DOCKER_BUILD_HOME "/dockerbuild"
# ====================
# Download and Install
# ~. tools
# 1. redis
# 2. wordpress
# ====================

WORKDIR $DOCKER_BUILD_HOME
RUN set -ex \
    # --------
	# ~. tools
	# --------
    && apk add --update git tcpdump tcptraceroute net-tools\
	&& cd /usr/bin \
	&& wget https://www.vdberg.org/~richard/tcpping \
	&& chmod 777 tcpping \
	# --------
	# 1. redis
	# --------
    && apk add --update redis \
    && apk add --update php7-redis \
	# ------------	
	# 2. wordpress
	# ------------
	&& mkdir -p $WORDPRESS_SOURCE \
    # cp in final
	# ----------
	# ~. upgrade/clean up
	# ----------
	&& apk update \
	&& apk upgrade \
	&& rm -rf /var/cache/apk/*

# =========
# Configure
# =========
# httpd confs
COPY httpd-wordpress.conf $HTTPD_CONF_DIR/

RUN set -ex \
	##
	&& ln -s $WORDPRESS_HOME /var/www/wordpress \
    ##
    && test -e /usr/local/bin/entrypoint.sh && mv /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.bak

# =====
# final
# =====
COPY wp-config.php $WORDPRESS_SOURCE/

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 2222 80
ENTRYPOINT ["entrypoint.sh"]
