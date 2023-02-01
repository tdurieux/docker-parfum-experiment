FROM nimmis/apache-php7
RUN apt-get update
RUN apt-get install --no-install-recommends -y php-dom && rm -rf /var/lib/apt/lists/*;
WORKDIR /var/www/html
COPY ./src/ .
COPY ./flag.php /etc/.flag.php

# add "expect" module for RCE demonstration
RUN apt-get install --no-install-recommends -y tcl-expect-dev php-pear php-pecl-http php7.0-dev && rm -rf /var/lib/apt/lists/*;
RUN pear channel-update pear.php.net
RUN pecl channel-update pecl.php.net
RUN pecl install expect
RUN sed -i 's/;extension=php_xsl.dll/;extension=php_xsl.dll\nextension=expect.so/' /etc/php/7.0/apache2/php.ini

# To demonstrate SSRF AWS, comment the following out if not required.
RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
COPY ./setup-aws-simulator.sh /
RUN chmod +x /setup-aws-simulator.sh

# set www-data as the owner
RUN chown -R "www-data:www-data" /var/www/html

# Set up entrypoint
ENTRYPOINT /setup-aws-simulator.sh && /my_init
#ENTRYPOINT /my_init
