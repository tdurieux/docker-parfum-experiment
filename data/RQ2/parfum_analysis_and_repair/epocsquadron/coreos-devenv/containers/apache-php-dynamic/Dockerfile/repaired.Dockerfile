# Start with Ubuntu base
FROM ubuntu:12.10

# Credit
MAINTAINER Daniel Poulin

# Install some basics
RUN apt-get update

# Install apache and php5
RUN apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php5 \
	php5-mysql \
	php5-gd \
	php5-curl \
	php5-mcrypt \
	php5-xdebug \
	php-apc \
	libapache2-mod-php5 && rm -rf /var/lib/apt/lists/*;

# Clean up after install
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Make sure all the desired apache modules are on
RUN a2enmod ssl headers rewrite vhost_alias

# Set up remote debugging for xdebug
RUN mkdir /var/run/apache2
ADD xdebug.ini /etc/php5/conf.d/xdebug.ini

# Set the default timezone
ADD timezone.ini /etc/php5/conf.d/timezone.ini

# Disable default site and replace with our own
ADD dynamic-vhost.conf /etc/apache2/sites-available/dynamic
ADD setDocRoot.php /etc/apache2/includes/
RUN a2dissite default && a2ensite dynamic

# Run apache on standard ports
EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/apache2ctl"]

CMD ["-D", "FOREGROUND"]
