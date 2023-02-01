FROM  ubuntu:trusty
RUN export DEBIAN_FRONTEND=noninteractive ; \
        apt-get -qqy update && \
        apt-get -qqy --no-install-recommends install apache2 php5 libapache2-mod-php5 php5-mcrypt && rm -rf /var/lib/apt/lists/*;
RUN   rm -f /var/www/html/index.html
ADD   example/index.php /var/www/html/
CMD   apache2ctl -D FOREGROUND
