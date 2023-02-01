FROM whiledo/letsencrypt-apache-ubuntu

ARG accesskey
ARG secretkey
ARG domainKey

#FROM ubuntu:16.04

# install dependencies
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apache2 \
	&& rm -r /var/lib/apt/lists/*

# Default command
CMD ["apachectl", "-D", "FOREGROUND"]

# Install Node.js
RUN apt-get update \
	&& apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends --yes nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes build-essential && rm -rf /var/lib/apt/lists/*;

#create directory html
RUN mkdir /var/www/html/dist
RUN mkdir -p /opt/app

# ssl certificate add
ADD cert /etc/ssl/cert
ADD privkey /etc/ssl/privkey

#working directory
WORKDIR /opt/app
ADD . /opt/app
RUN npm install && npm cache clean --force;

#build application
RUN npm run build
RUN cp -a -f /opt/app/dist/* /var/www/html/
RUN cp /opt/app/.htaccess /var/www/html/
RUN cp /opt/app/vhost_ssl_master.conf /etc/apache2/sites-enabled/
RUN cp /opt/app/vhost_ssl_develop.conf /etc/apache2/sites-enabled/
RUN cp /opt/app/vhost_ssl_qa.conf /etc/apache2/sites-enabled/
RUN cp /opt/app/vhost_ssl_staging.conf /etc/apache2/sites-enabled/
RUN rm -rf /opt/app/*
RUN a2enmod rewrite
RUN a2enmod ssl
RUN service apache2 restart


# Ports
EXPOSE 80 443
