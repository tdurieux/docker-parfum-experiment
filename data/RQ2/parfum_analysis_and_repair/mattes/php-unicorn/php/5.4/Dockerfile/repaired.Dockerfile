FROM tianon/debian:wheezy
MAINTAINER Matthias Kadenbach <matthias.kadenbach@gmail.com>

RUN apt-get update
RUN apt-get --force-yes --no-install-recommends -y install php5-fpm php5-mysql && rm -rf /var/lib/apt/lists/*;

RUN mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.backup
ADD php-fpm-www.conf /etc/php5/fpm/pool.d/www.conf

RUN sed -i -e 's/;daemonize = yes/daemonize = no/' /etc/php5/fpm/php-fpm.conf

# ip redirecting setup
RUN apt-get --force-yes --no-install-recommends -y install rinetd && rm -rf /var/lib/apt/lists/*;
RUN cp /etc/rinetd.conf /etc/rinetd.conf.backup

# add start script
ADD start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh


# bind volumes
VOLUME ["/www"]

# expose ports
EXPOSE 20054

# run command
CMD ["start.sh"]
