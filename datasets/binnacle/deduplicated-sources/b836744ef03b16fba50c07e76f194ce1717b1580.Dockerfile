FROM vipconsult/base:squeeze
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

RUN apt-get install \
        php5 \
        php5-fpm \
        php5-gd \
        php5-imagick \
        php5-mysql \
        php5-mcrypt \
        php5-curl \
        php5-cli \
        php5-dev \
        php5-memcache \
        ssmtp && \
        apt-get purge -y --auto-remove && \
        rm -rf /var/lib/apt/lists/* && \
        apt-get clean


RUN sed -i -e "s/^.*FromLineOverride.*$/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf && \
    sed -i -e "s/.*max_input_time =.*/max_input_time = 300/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/.*session.gc_divisor =.*/session.gc_divisor = 100/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/.*session.gc_maxlifetime =.*/session.gc_maxlifetime = 315360000/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/.*serialize_precision =.*/serialize_precision = 100/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/.*short_open_tag =.*/short_open_tag = On/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/.*daemonize =.*/daemonize = no/" /etc/php5/fpm/php-fpm.conf && \
    # sed -i -e "s/.*access.log =.*/access.log = \/dev\/null/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/.*error_log =.*/error_log = \/proc\/self\/fd\/2/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/.*pm.status_path =.*/pm.status_path = \/status/" /etc/php5/fpm/pool.d/www.conf


ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php5-fpm", "-c","/etc/php5/fpm"]
