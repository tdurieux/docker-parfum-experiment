# Creates wordpress install
#
# Author: Paul Czarkowski
# Date: 08/11/2013


FROM paulczar/apache2-php
MAINTAINER Paul Czarkowski "paul@paulcz.net"

RUN apt-get -y --no-install-recommends install php5-mysql && rm -rf /var/lib/apt/lists/*;

ADD wordpress /var/www
ADD start /wordpress/start
RUN chmod 700 /wordpress/start
ADD wordpress.sql /wordpress/wordpress.sql

CMD ["/wordpress/start"]