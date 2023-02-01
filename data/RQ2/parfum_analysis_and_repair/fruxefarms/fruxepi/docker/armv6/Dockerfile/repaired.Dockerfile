# FRXPI ARMv6 Dockerfile
FROM balenalib/raspberry-pi-debian:jessie-build

LABEL maintainer="dev@fruxe.co"

# Install Dependencies
RUN apt-get update && \
  apt-get install --no-install-recommends -y apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt cron nano git unzip && \
  apt-get install --no-install-recommends -y python python-dev python-pip && \
  pip install --no-cache-dir --upgrade pip setuptools wheel && \
  pip install --no-cache-dir Adafruit_DHT pymysql RPi.GPIO && rm -rf /var/lib/apt/lists/*;

# Configure Apache
RUN a2enmod rewrite
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Configure MySQL
ADD mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Sudo access for www-data user
RUN apt-get install --no-install-recommends -y sudo && \
  usermod -a -G sudo www-data && \
  echo "www-data ALL=(root) NOPASSWD: /var/www/html/actions/fruxepi.py" > /etc/sudoers.d/www-data && \
  chmod 0440 /etc/sudoers.d/www-data && rm -rf /var/lib/apt/lists/*;

# WiringPi Install
RUN git clone https://github.com/WiringPi/WiringPi.git &&\
  cd WiringPi && \
  ./build

# CRON Setup
ADD crontab /tmp/crontab
ADD cron_init.sh /tmp/cron_init.sh

# Start Apache
# CMD ["apachectl", "-D", "FOREGROUND"]
COPY start.sh /start.sh
CMD ["./start.sh"]
