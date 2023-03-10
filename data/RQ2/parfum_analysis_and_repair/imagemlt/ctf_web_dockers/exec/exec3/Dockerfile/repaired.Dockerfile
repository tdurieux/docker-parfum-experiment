FROM ubuntu:trusty
ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $PATH:$HTTPD_PREFIX/bin
RUN mkdir -p "$HTTPD_PREFIX" \
	&& chown www-data:www-data "$HTTPD_PREFIX"
WORKDIR $HTTPD_PREFIX

# install httpd runtime dependencies
# https://httpd.apache.org/docs/2.4/install.html#requirements
RUN apt-get update \
	&& apt-get install --no-install-recommends apache2 php5 -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY *.php /var/www/html/

RUN chmod a+w /var/www/html \
	&& rm /var/www/html/index.html

COPY httpd-foreground /usr/local/bin/

EXPOSE 80
CMD ["httpd-foreground"]

