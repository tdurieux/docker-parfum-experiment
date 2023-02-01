FROM alpine:edge

ENV TERM="xterm"
ENV XDEBUG_MODE="profile"
ENV XDEBUG_CONFIG="output_dir=/tmp start_with_request=trigger trigger_value="

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  bash \
  ca-certificates \
  curl \
  curl \
  freetype-dev \
  g++ \
  gcc \
  git \
  gmp-dev \
  grep \
  imagemagick-dev \
  less \
  libmcrypt-dev \
  libpng-dev \
  make \
  mariadb \
  mariadb-server-utils \
  mysql-client \
  nginx \
  openssh \
  openssh-keygen \
  php7-bcmath \
  php7-ctype \
  php7-curl \
  php7-dev \
  php7-dom \
  php7-fileinfo \
  php7-fpm \
  php7-ftp \
  php7-gd \
  php7-gmp \
  php7-iconv \
  php7-intl \
  php7-json \
  php7-mbstring \
  php7-mysqli \
  php7-opcache \
  php7-openssl \
  php7-pdo_mysql \
  php7-pecl-xdebug \
  php7-phar \
  php7-session \
  php7-simplexml \
  php7-tokenizer \
  php7-xml \
  php7-xmlreader \
  php7-xmlwriter \
  php7-zip \
  php7-zlib \
  procps \
  sed \
  tmux \
  tzdata \
  vim \
  wget \
  zip \
  zlib-dev \
  && apk add -u musl && \
  rm -rf /var/cache/apk/*

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    composer && \
    rm -rf /var/cache/apk/*

# install Image Magick
RUN git clone https://github.com/Imagick/imagick && \
  cd imagick && \
  phpize && ./configure && \
  make && \
  make install && \
  cd ../ && \
  rm -rf imagick && \
  apk add php7-pecl-imagick

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = -1/g' /etc/php7/php.ini && \ 
    sed -i 's/max_execution_time = 30/max_execution_time = 0/g' /etc/php7/php.ini && \ 
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php7/php.ini && \
    sed -i 's/;zend_extension=xdebug.so/zend_extension=xdebug.so/g' /etc/php7/conf.d/50_xdebug.ini && \
    # do away with the nginx user stuff if running as root? \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    # dubious about this one - seems to have been fine without
    ln -s /sbin/php-fpm7 /sbin/php-fpm

ADD ./php7/conf/nginx.conf /etc/nginx/
ADD ./php7/conf/php-fpm.conf /etc/php7/
ADD ./php7/conf/.vimrc /root/
ADD ./php7/conf/.tmux.conf /root/
ADD ./php7/scripts/run.sh /
ADD ./php7/scripts/second_run.sh /
ADD ./php7/scripts/backup_site.sh /
ADD ./php7/installers /installers
ADD ./php7/scripts/mysql_setup.sql /
ADD ./php7/scripts/mysql_user.sql /
ADD ./php7/scripts/mysql_user.sql /
ADD ./php7/scripts/install_default_plugins.sh /

RUN chmod +x /run.sh && \
    chmod +x /backup_site.sh && \
    chmod +x /installers/wp-cli.phar && mv installers/wp-cli.phar /usr/bin/wp && chown root:root /usr/bin/wp

# mariadb setup
RUN mkdir -p /run/mysqld

RUN mysql_install_db --user=root --basedir=/usr --datadir=/var/lib/mysql 

# create WP database
RUN /usr/bin/mysqld --user=root --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < /mysql_setup.sql

RUN mkdir -p /usr/html

WORKDIR /usr/html
# extract WordPress to web root
RUN unzip -q /installers/wordpress-latest.zip -d /tmp
RUN cp -r /tmp/wordpress/* /usr/html/
RUN rm -Rf /tmp/wordpress

# extract phpMyAdmin to /usr/html/phpmyadmin/
RUN unzip -q /installers/phpMyAdmin-5.1.1-all-languages.zip -d /tmp
RUN mv /tmp/phpMyAdmin-5.1.1-all-languages /usr/html/phpmyadmin/
RUN rm -Rf /tmp/phpMyAdmin-5.1.1-all-languages

# allow autologin for phpmyadmin
RUN mv /usr/html/phpmyadmin/config.sample.inc.php /usr/html/phpmyadmin/config.inc.php
RUN echo "\$cfg['Servers'][\$i]['auth_type'] = 'config';" >> /usr/html/phpmyadmin/config.inc.php
RUN echo "\$cfg['Servers'][\$i]['username'] = 'root';" >> /usr/html/phpmyadmin/config.inc.php
RUN echo "\$cfg['Servers'][\$i]['password'] = 'banana';" >> /usr/html/phpmyadmin/config.inc.php


# show user/pwd hint on login screen
RUN grep -Rl 'Username or Email Address' | xargs sed -i 's/Username or Email Address/User (u\/p: admin\/admin)/g'

# install all default plugins
RUN sh /install_default_plugins.sh
# cleanup
RUN rm -Rf /installers

# set web root permissions
# TODO: no longer needed if all root?
RUN chown -R root:root /usr/html/

EXPOSE 4000-5000
# EXPOSE 4444
#VOLUME ["/usr/html"]

CMD ["/run.sh"]
