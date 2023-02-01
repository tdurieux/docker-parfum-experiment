FROM alpine:edge

ENV TERM="xterm"

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
  php8-bcmath \
  php8-ctype \
  php8-curl \
  php8-dev \
  php8-dom \
  php8-fileinfo \
  php8-fpm \
  php8-ftp \
  php8-gd \
  php8-gmp \
  php8-iconv \
  php8-intl \
  php8-json \
  php8-mbstring \
  php8-mysqli \
  php8-opcache \
  php8-openssl \
  php8-pdo_mysql \
  php8-phar \
  php8-session \
  php8-simplexml \
  php8-tokenizer \
  php8-xml \
  php8-xmlreader \
  php8-xmlwriter \
  php8-zip \
  php8-zlib \
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

# normalize some php8 bins
RUN ln -s /usr/bin/php8 /usr/bin/php && \
  ln -s /usr/bin/phpize8 /usr/bin/phpize && \
  ln -s /usr/bin/php-config8 /usr/bin/php-config

# install Image Magick
RUN git clone https://github.com/Imagick/imagick && \
  cd imagick && \
  phpize8 && ./configure && \
  make && \
  make install && \
  cd ../ && \
  rm -rf imagick && \
  apk add php8-pecl-imagick

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php8/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = -1/g' /etc/php8/php.ini && \ 
    sed -i 's/max_execution_time = 30/max_execution_time = 0/g' /etc/php8/php.ini && \ 
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php8/php.ini && \
    # do away with the nginx user stuff if running as root? \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    # dubious about this one - seems to have been fine without
    ln -s /sbin/php-fpm8 /sbin/php-fpm

ADD ./php8/conf/nginx.conf /etc/nginx/
ADD ./php8/conf/php-fpm.conf /etc/php8/
ADD ./php8/conf/.vimrc /root/
ADD ./php8/conf/.tmux.conf /root/
ADD ./php8/scripts/run.sh /
ADD ./php8/scripts/second_run.sh /
ADD ./php8/scripts/backup_site.sh /
ADD ./php8/installers /installers
ADD ./php8/scripts/mysql_setup.sql /
ADD ./php8/scripts/mysql_user.sql /
ADD ./php8/scripts/mysql_user.sql /
ADD ./php8/scripts/install_default_plugins.sh /

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
