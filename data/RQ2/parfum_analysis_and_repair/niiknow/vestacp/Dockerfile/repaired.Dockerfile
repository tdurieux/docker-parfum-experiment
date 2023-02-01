FROM niiknow/docker-hostingbase:1.6.1
LABEL maintainer="noogen <friends@niiknow.org>"
ENV DEBIAN_FRONTEND=noninteractive \
    VESTA=/usr/local/vesta \
    GOLANG_VERSION=1.15.5 \
    NGINX_BUILD_DIR=/usr/src/nginx \
    NGINX_DEVEL_KIT_VERSION=0.3.0 NGINX_SET_MISC_MODULE_VERSION=0.32 \
    NGINX_VERSION=1.18.0 \
    NGINX_PAGESPEED_VERSION=1.13.35.2 \
    NGINX_PSOL_VERSION=1.13.35.2 \
    IMAGE_FILTER_URL=https://raw.githubusercontent.com/niiknow/docker-nginx-image-proxy/master/build/ngx_http_image_filter_module.c

RUN cd /tmp \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 91FA4AD5 \
    && add-apt-repository ppa:deadsnakes/ppa \
    && add-apt-repository ppa:maxmind/ppa -y \
    && echo "nginx mysql bind clamav ssl-cert dovecot dovenull Debian-exim postgres debian-spamd epmd couchdb memcache mongodb redis" | xargs -n1 groupadd -K GID_MIN=100 -K GID_MAX=999 ${g} \
    && echo "nginx nginx mysql mysql bind bind clamav clamav dovecot dovecot dovenull dovenull Debian-exim Debian-exim postgres postgres debian-spamd debian-spamd epmd epmd couchdb couchdb memcache memcache mongodb mongodb redis redis" | xargs -n2 useradd -d /nonexistent -s /bin/false -K UID_MIN=100 -K UID_MAX=999 -g ${g} \
    && usermod -d /var/lib/mysql mysql \
    && usermod -d /var/cache/bind bind \
    && usermod -d /var/lib/clamav -a -G Debian-exim clamav && usermod -a -G mail clamav \
    && usermod -d /usr/lib/dovecot -a -G mail dovecot \
    && usermod -d /var/spool/exim4 -a -G mail Debian-exim \
    && usermod -d /var/lib/postgresql -s /bin/bash -a -G ssl-cert postgres \
    && usermod -d /var/lib/spamassassin -s /bin/sh -a -G mail debian-spamd \
    && usermod -d /var/run/epmd epmd \
    && usermod -d /var/lib/couchdb -s /bin/bash couchdb \
    && usermod -d /var/lib/mongodb -a -G nogroup mongodb \
    && usermod -d /var/lib/redis redis \
    && add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
    && curl -f -sL "https://github.com/simplresty/ngx_devel_kit/archive/v$NGINX_DEVEL_KIT_VERSION.tar.gz" -o dev-kit.tar.gz \
    && mkdir -p /usr/src/nginx/ngx_devel_kit \
    && tar -xof dev-kit.tar.gz -C /usr/src/nginx/ngx_devel_kit --strip-components=1 \
    && rm dev-kit.tar.gz \
    && curl -f -sL "https://github.com/openresty/set-misc-nginx-module/archive/v$NGINX_SET_MISC_MODULE_VERSION.tar.gz" -o ngx-misc.tar.gz \
    && mkdir -p /usr/src/nginx/set-misc-nginx-module \
    && tar -xof ngx-misc.tar.gz -C /usr/src/nginx/set-misc-nginx-module --strip-components=1 \
    && rm ngx-misc.tar.gz \
    && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
    && cp /etc/apt/sources.list /etc/apt/sources.list.bak \
    && echo "deb http://nginx.org/packages/ubuntu/ xenial nginx" | tee -a /etc/apt/sources.list \
    && echo "deb-src http://nginx.org/packages/ubuntu/ xenial nginx" | tee -a /etc/apt/sources.list \
    && apt-get update && apt-get -yf -o Dpkg::Options::="--force-confold"  --no-install-recommends upgrade \
    && curl -f -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
    && apt-get install -yf -o Dpkg::Options::="--force-confold" --no-install-recommends libpcre3-dev libssl-dev dpkg-dev libmaxminddb0 libmaxminddb-dev mmdb-bin libgd-dev iproute uuid-dev pwgen \
    && mkdir -p ${NGINX_BUILD_DIR} \
    && cd ${NGINX_BUILD_DIR} \
    && git clone https://github.com/leev/ngx_http_geoip2_module ngx_http_geoip2_module \
    && apt-get source nginx=${NGINX_VERSION} -y \
    && mv ${NGINX_BUILD_DIR}/nginx-${NGINX_VERSION}/src/http/modules/ngx_http_image_filter_module.c ${NGINX_BUILD_DIR}/nginx-${NGINX_VERSION}/src/http/modules/ngx_http_image_filter_module.bak \
    && curl -f -SL $IMAGE_FILTER_URL --output ${NGINX_BUILD_DIR}/nginx-${NGINX_VERSION}/src/http/modules/ngx_http_image_filter_module.c \
    && sed -i "s/--with-http_ssl_module/--with-http_ssl_module --with-http_image_filter_module --add-module=\/usr\/src\/nginx\/ngx_http_geoip2_module --add-module=\/usr\/src\/nginx\/ngx_devel_kit --add-module=\/usr\/src\/nginx\/set-misc-nginx-module --add-module=\/usr\/src\/nginx\/ngx_pagespeed-latest-stable/g" ${NGINX_BUILD_DIR}/nginx-${NGINX_VERSION}/debian/rules \
    && curl -f -SL https://github.com/apache/incubator-pagespeed-ngx/archive/v${NGINX_PAGESPEED_VERSION}-stable.zip -o latest-stable.zip \
    && unzip latest-stable.zip \
    && mv incubator-pagespeed-ngx-${NGINX_PAGESPEED_VERSION}-stable ngx_pagespeed-latest-stable \
    && cd ngx_pagespeed-latest-stable \
    && curl -f -SL https://dl.google.com/dl/page-speed/psol/${NGINX_PSOL_VERSION}-x64.tar.gz -o ${NGINX_PSOL_VERSION}.tar.gz \
    && tar -xzf ${NGINX_PSOL_VERSION}.tar.gz \
    && apt-get build-dep nginx -y \
    && cd ${NGINX_BUILD_DIR}/nginx-${NGINX_VERSION}; rm -rf /usr/src/nginx/ngx_devel_kit rm ${NGINX_PSOL_VERSION}.tar.gz rm -rf /var/lib/apt/lists/*; dpkg-buildpackage -uc -us -b \
    && cd ${NGINX_BUILD_DIR} \
    && dpkg -i nginx_${NGINX_VERSION}-2~xenial_amd64.deb \
    && apt-get install --no-install-recommends -yq php8.0-mbstring php8.0-cgi php8.0-cli php8.0-dev php8.0-common php8.0-sybase php8.0-curl \
        php8.0-enchant php8.0-imap php8.0-xsl php8.0-mysql php8.0-mysqli php8.0-mysqlnd php8.0-pspell php8.0-gd php8.0-zip \
        php8.0-tidy php8.0-opcache php8.0-bz2 php8.0-pgsql php8.0-readline php8.0-imagick php7.3-phar \
        php8.0-intl php8.0-sqlite3 php8.0-ldap php8.0-xml php8.0-redis php8.0-fpm \
        php8.0-soap php8.0-bcmath php8.0-fileinfo php8.0-xdebug php8.0-exif php8.0-tokenizer \
    && apt-get install --no-install-recommends -yq php7.4-mbstring php7.4-cgi php7.4-cli php7.4-dev php7.4-geoip php7.4-common php7.4-xmlrpc php7.4-sybase php7.4-curl \
        php7.4-enchant php7.4-imap php7.4-xsl php7.4-mysql php7.4-mysqli php7.4-mysqlnd php7.4-pspell php7.4-gd php7.4-zip \
        php7.4-tidy php7.4-opcache php7.4-json php7.4-bz2 php7.4-pgsql php7.4-readline php7.4-imagick php7.3-phar \
        php7.4-intl php7.4-sqlite3 php7.4-ldap php7.4-xml php7.4-redis php7.4-fpm \
        php7.4-soap php7.4-bcmath php7.4-fileinfo php7.4-xdebug php7.4-exif php7.4-tokenizer \
    && apt-get install --no-install-recommends -yq php7.3-mbstring php7.3-cgi php7.3-cli php7.3-dev php7.3-geoip php7.3-common php7.3-xmlrpc php7.3-sybase php7.3-curl \
        php7.3-enchant php7.3-imap php7.3-xsl php7.3-mysql php7.3-mysqli php7.3-mysqlnd php7.3-pspell php7.3-gd php7.3-zip \
        php7.3-tidy php7.3-opcache php7.3-json php7.3-bz2 php7.3-pgsql php7.3-readline php7.3-imagick php7.3-phar \
        php7.3-intl php7.3-sqlite3 php7.3-ldap php7.3-xml php7.3-redis php7.3-fpm \
        php7.3-soap php7.3-bcmath php7.3-fileinfo php7.3-xdebug php7.3-exif php7.3-tokenizer \
       
t ginx on hold so it \
    && apt-mark hold nginx \
    && rm -f /etc/apt/source \
    && rm -rf /usr/s \
    && rm -rf /tmp/* \
    && apt-get -yf a

RUN cd /tmp \
    && touch /var/log/auth.log \
# begin setup for vesta \
    && curl -f -SL https://raw.githubusercontent.com/serghey-rodin/vesta/a6d498e7e2088cc5d3b1d88cbcbea6a739d02ef1/install/vst-install-ubuntu.sh -o /tmp/vst-install-ubuntu.sh \
    && sed -i -e "s/software\=\"nginx /software\=\"/g" /tmp/vst-install-ubuntu.sh \
   
x ariadb instead of mysql \
        && sed -i -e "s/mysql\-/mariadb
    \
# fix postgres-9.6 instead o
    && sed -i -e "s/postgresql postgresql-con \
   
ne ate secure password
    && pwgen -c -n -1 12 > $HOME/password.txt \

# begin install vesta
    && bash /tmp/vst-install-ubuntu.sh \
        --nginx yes --apache yes --phpfpm no \
        --vsftpd no --proftpd no \
        --named yes --exim yes --dovecot yes \
        --spamas \
                --iptables yes
           --mysql yes --postg es l yes --remi yes \
                --quota no --passwo
           -y no -f \

# begin apache stuff \
        && service apache2 stop && service vesta stop \
    
# install additional mods
    && apt-get install -yf --no-install \
                postgresql-9.6
           postgresql-9.6-postgis-2.5-scripts postgr \
       
st ll m -f mca hed, redis-server, openvpn, mongodb, d tn t-sdk, and c \
    && apt-get install -y \
           openvpn mongodb-or \
                libgs-dev
        \
fa lt p -f tho  3.7 \
    && ln -sf $(which python3 \
   
tt ng upawscli, golang, and awscli \
        && curl -sS "https
    && python3 get-pip.py \
    && pip3 install \
   
tt ng golang

COPY rootfs/. /

RUN cd /tmp \
# tweaks
    && chmod +x /etc/init.d/dovecot \
    && chmod +x /etc/service/sshd/run \
    && chmod +x /etc/init.d/mongod \
    && chmod +x /etc/my_init.d/!0_startup.sh \
    && mv /sysprepz/admin/bin/vesta-*.sh /bin \

# install iconcube loader extension
    # && /bin/vesta-ioncube-install.sh 8.0 \
    && /bin/vesta-ioncube-install.sh 7.4 \
    && /bin/vesta-ioncube-install.sh 7.3 \

# make sure we default fcgi and php to 7.4
    && mv /usr/bin/php-cgi /usr/bin \
    && ln - -f  /u r/bin/php-cgi7.4 /usr/bin/php-cgi \
        && /usr/bin/switch-php.sh "7.
    && curl -sS https://getcomposer.o g/ nstaller | php -- --install-di \
   
mo e phpmyadmin, phppgadmin \
    && rm - -f f / sr/share/phpmyadmin/* && rm -rf /u r/share/ hppgadmin/* \
   
st ll adminer \
    && rm -rf /usr/share/adminer && mkdir -p /usr/sha \
    && curl -SL https://www.adminer.org/latest.php --output /usr/share/adminer/public/i \
   
# overwrite (php
    && mkdir -p /etc/nginx/conf-d \
    && rsync -a /etc/nginx/conf.d/* /etc/nginx/conf-d \
    && echo 'include /etc/nginx/conf.d/dbadmin.inc;' > /etc/nginx/conf.d/phpmyadmin.in \
    && echo 'include /etc/nginx/conf.d/dbadmin.inc;' > /etc/nginx/conf.d/phppgadmin.in \
   
ti ate ini \
    && echo "extension=v8js.so" > /etc/php/7.4/mods-available/v8js.ini \
    && ln -sf /etc/php/7.4/mods-available/v8js.ini /etc/php/7.4/apache2/conf.d/20-v8js \
    && ln -sf /etc/php/7.4/mods-available/v8js.ini /etc/php/7.4/cli/conf.d/20-v8js.ini \
    && ln -sf /etc/php/7.4/mods-available/v8js.ini /etc/php/7.4/cgi/conf.d/20-v8js.ini \
    && ln -sf /etc/php/7.4/mods-available/v8js.ini /etc/php/7.4/fpm/ \

    && echo "extension=v8js.so" > /etc/php/7.3/mods-available/v8js.ini \
    && ln -sf /etc/php/7.3/mods-available/v8js.ini /etc/php/7.3/apache2/conf.d/20-v8 \
    && ln -sf /etc/php/7.3/mods-available/v8js.ini /etc/php/7.3/cli/conf.d/20-v8js.i \
    && ln -sf /etc/php/7.3/mods-available/v8js.ini /etc/php/7.3/cgi/ \
    && ln -sf /etc/php/7.3/mods-available/v8js.ini /etc/php/7.3/fpm/conf.d/20-v8js.ini \

    && echo "extension=pcs.so" > /etc/php/7.4/mods-available/pcs.ini \
    && ln -sf /etc/php/7.4/mods-available/pcs.ini /etc/php/7.4/apache2/conf.d/15-pcs \
    && ln -sf /etc/php/7.4/mods-available/pcs.ini /etc/php/7.4/cli/conf.d/15-pcs \
    && ln -sf /etc/php/7.4/mods-available/pcs.ini /etc/php/7.4/cgi/conf.d/15-pcs.ini \
    && ln -sf /etc/php/7.4/mods-available/pcs.ini /etc/php/7.4/fpm/conf.d/15-pcs.ini \

    && echo "extension=pcs.so" > /etc/php/7.3/mods-available/pcs.ini \
    && ln -sf /etc/php/7.3/mods-available/pcs.ini /etc/php/7.3/apache2/conf.d/15 \
    && ln -sf /etc/php/7.3/mods-available/pcs.ini /etc/php/7.3/cli/conf.d/15-pcs.ini \
    && ln -sf /etc/php/7.3/mods-available/pcs.ini /etc/php/7.3/cgi/conf.d/15-pcs.ini \
    && ln -sf /etc/php/7.3/mods-available/pcs.ini /etc/php/7.3/fpm/conf.d/15-pcs.ini \

        && echo "extension
    && ln -sf /etc/php/7.4/mods-available/couchbase.ini /et \
        && ln -sf /etc/php/7.4/mods-available/couch
    && ln -sf /etc/php/7.4/mods-available/couchbase.ini /e \
        && ln -sf /et
    \
    && echo "extension=couchbase.so" > /etc/php/7.3/mods-available/couchbase.ini \
    && ln -sf /etc/php/7.3/mods-available/couchbase.ini /etc/php/7.3/apache2/conf.d/30 \
        && ln -sf
    && ln -sf /etc/php/7.3/mods-available/couchbase.ini /etc/php/7.3/cgi/conf.d/30-couchbase.ini \
    && ln -sf /etc/php/7.3/mods-available/couchbase.ini /etc/php/7.3/fpm/conf.d/30-c \
   
rf rmance tweaks \
    && chmod 0755 /etc/init.d \
   
cr ase memcache max size from 64m to 256m \
    && sed -i -e "s/^\-m 64 \
   
uc db stuff \
    && mkdir -p /var/lib/couchdb \
    && chown -R couchdb:couchd \
    && chmod -R 0770 /usr/bin/couchdb /etc \
   
cu e ssh \
        && sed -i -e "s/PermitRootLogi
    && sed -i -e "s/^#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config \
   
# initialize ips for docker support
    && cd /usr/local/vesta/data/ips && mv * 127.0.0.1 \
    && cd /etc/apache2/conf.d \
    && sed -i -e "s/172.*.*.*:80/127.0.0.1:80/g" * \
    && sed -i -e "s/172.*.*.*:8443/127.0.0.1:8443/g" * \
    && cd /etc/nginx/conf.d \
    && sed -i -e "s/172.*.*.*:80/127.0.0.1:80/g" * \
    && sed -i -e "s/172.*.*.*:8080/127.0.0.1:8080/g" * \
    && mv 172.*.*.*.conf 127.0.0.1.conf \
    && cd /home/admin/conf/web \
    && sed -i -e "s/172.*.*.*:80;/80;/g" * \
    && sed -i -e "s/172.*.*.*:8080/127.0.0.1:8080/g" * \

    && cd /tmp \
   
st res patch for this docker \
    && sed -i -e "s/%q%u@%d '/%q%u@%d %r '/g" /etc/postgresql/9.6/main/postgresql.c \
    && sed -i -e "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/pos \
   
p tuff - after vesta because of vesta-php installs \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/8.0 \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/8.0/cli \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/8.0 \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/8.0 \

    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.4/apach \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.4/c \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.4/c \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.4/f \

    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.3/a \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.3/c \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.3/c \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 600M/" /etc/php/7.3/fpm/p \

    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/8.0/apache2/php.i \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/8.0/cli/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/8.0/cgi/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/8.0/fpm/php.ini \

    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.4/apache2/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.4/cli/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.4/cgi/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.4/fpm/php.ini \

    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.3/apache2/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.3/cli/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.3/cgi/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 600M/" /etc/php/7.3/fpm/php.ini \

    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/8.0/apache2/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/8.0/cli/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/8.0/cgi/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/8.0/fpm/php.ini \

    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.4/apache2/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.4/cli/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.4/cgi/php.ini \
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.4/fpm/php.ini \

    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.3/apache2/php.ini \
        && sed -i "s/max_input_time = 60/m
    && sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.3/cgi/php.ini \
        && sed -i "s/max_input_t
    \
    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/8.0/apache2/php.ini \
        && sed -i "s/max_execution_tim
    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/8.0/cgi/php.ini \
    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/8.0/fpm/php.ini \

    && sed -i "s/max_execution_time = 30/max_exe \
        && sed -i "s/max_execution_time = 30/max_e
    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.4/cgi/php.i \
    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.4/fpm/p \

    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.3/apache2/php.ini \
        && sed -i "s/max_execution_time = 30/max_exec
    && sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.3/cgi/php.ini \
        && sed -i "s/max_exec
    \
    && sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exim \-t/g" /etc/php/8.0/apache2 \
    && sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exi \
    && sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exim \-t/g" /etc/php/8.0/cgi \
    && sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exim \-t/g" \

    && sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/e \
    && sed -i -e "s/;s nd ail_path =/send ai _path = \/usr\/ bi \/exim \-t/g" \
        && sed -i -e "s/;sendmail_path =/sendmail_pa
    && sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/e \

    && sed -i -e "s/;sendmail_ at  =/sendmail_path = \/usr\/sb \
    && sed -i -e "s/;sendmail_pa h /sendmail_path = \/usr\/sbin\/ \
    && sed -i -e "s/;sendmai _p th =/sendmail_path = \/usr \
    && sed -i -e "s/;send ai _path =/sendmail_path = \
   
t ame upload limit for php fcgi \
        && sed -i "s/Fc
    \
# sed for docker single IP
    && sed -i -e "s/\%ip\%\:\%proxy\_port\%/\%proxy\_port\%/g" /usr/local/vesta/data/templates/web/nginx/*.tpl \
    && sed -i -e "s/\%ip\%\:\%proxy\_ssl\_port\%/\%proxy\_ssl\_port\%/g" /usr/local/vesta/data/templates/web/nginx/*.stpl \
# sed to include additional conf
    && sed -i -e "s/ include \%home\%\/\%user\%\/conf\/web\/nginx\.\%domain\%/ include \%home\%\/\%user\%\/web\/\%domain\%\/private\/*.conf;\n    include \%home\%\/\%user\%\/conf\/web\/nginx\.\%domain\%/g" /usr/local/vesta/data/templates/web/nginx/*.tpl \
    && sed -i -e "s/ include \%home\%\/\%user\%\/conf\/web\/snginx\.\%domain\%/ include \%home\%\/\%user\%\/web\/\%domain\%\/private\/*.conf;\n    include \%home\%\/\%user\%\/conf\/web\/snginx\.\%domain\%/g" /usr/local/vesta/data/templates/web/nginx/*.stpl \
# patch for logging remote \
    && bash /usr/local/vesta/upd/switch_rpath.sh \
   
d ultiple php fcgi and custom \
    && rsync -a /sysprepz/apache2-templates/* /usr/local/ \
    && rsync -a /sysprepz/nginx-templates/ \
   
# docker specific patching
    && sed -i -e "s/^if (\$dir_n \
   
cr ase open file limit for ngi \
    && echo "\n\n* soft nofile 800000\n* hard n \
   
tc  psql9.5+ backup \
    && sed -i -e "s/\-c \-\-inserts \-O \
    && sed -i -e "s/\- \
    && sed -i -e "s/dbuser/DBUSER/g" \
    && sed -i -e "s/ROLE \$DBUSER/ROLE \$DBUSER W \
    && sed -i -e "s/plsql/p \
   
ac e stuff, default php7.4 \
    && echo "\nServerN \
    && a2enmod headers && a2dismod p \
   
sa le localhost redi \
    && sed -i -e "s/^NAT=.*/NAT=\'\'/g" \
    && service mysql stop && systemctl disabl \
    && service postgresq \
    && service redis-server stop && syst \
    && service fail2ban stop && systemctl disable fail2ban \
    && service nginx stop && sy \
    && service apache2 stop && systemctl disable apach \
    && sed -i -e "s/\/var\/lib\/mysql/\/ves \
   
r etsencrypt \
    && touch /usr/local/vesta/data/queue/lets \
   
tu  redis like memcache \
    && sed -i -e 's:^save:# save \
        e 's:^bind:# bind:g' \
        e 's:^logfile:# logfile:' \
        e 's:# maxmemory \(.*\) \
        e 's:# maxmemory-policy \(.*\)$:maxmemory-pol \
        etc/redis/redis.conf \
    && sed -i -e "s/\/etc\/redis/\/vesta\/ \
   
sa le php*admin and roun \
    && mkdir -p /etc/apache2/conf-d \
    && rsync -a /etc/apache2/conf.d/* /etc/apac \
    && rm -f /etc/apache2/ \
    && rm -f /etc/apache2/conf.d/roundcube.c \
   
gi  folder redirection \
    && mkdir -p /vesta-start/etc \
    && mkdir -p /vesta-start/var/lib \
    && mkdir -p /vesta-sta \

    && mv /etc/apache2 /vesta-start/etc/apach \
    && rm -rf /etc/apach \
    && ln -s /vesta/etc/apache2 /etc/apa \

    && mv /etc/ssh /vesta-st \
    && rm -rf /etc/ssh \
    && ln -s /vesta/etc/ssh /etc/ssh \

    && mv /etc/fail2ban /vesta-start/etc/fail2ban \
    && rm -rf /etc/fail2ban \
    && ln -s /vesta/etc/fail2ban \

    && mv /etc/php /vesta-start/e \
    && rm -rf /etc/ \
    && ln -s /vesta/etc/php /e \

    && mv /etc/nginx   /vesta- \
    && rm -rf /etc/nginx \
    && ln -s /vesta/etc/nginx /etc/nginx \

    && mv /etc/exim4   /vesta-start/etc/exim4 \
    && rm -rf /etc/exim4 \
    && ln -s /vesta/etc/exi \

    && mv /etc/spamassassin   /vesta-star \
    && rm -rf /etc/spam \
    && ln -s /vesta/etc/spamassassin / \

    && mv /etc/mail   /ves \
    && rm -rf /etc/mail \
    && ln -s /vesta/etc/mail /etc/mail \

    && mv /etc/redis   /vesta-start/ \
    && rm -rf /etc/redis \
    && ln -s /vesta/etc/redis \

    && mkdir -p /var/lib/mongodb \
    && chown -R mongodb:mo \
    && mv /var/lib/mongodb /vesta-start/var/ \
    && rm -rf /var/lib/mongodb \
    && ln -s /vesta/var/lib/mo \

    && mkdir -p /var/lib/redis \
    && chown -R redis:redis /var/lib/r \
    && mv /var/lib/redis /vesta-start/var/lib/redi \
    && rm -rf /var/lib/redis \
    && ln -s /vesta/var/lib/redis /var/lib/redis \

    && mv /etc/awstats /vesta-start/etc/awstats \
        && rm -rf /etc/awstats \
    && ln -s /vesta/etc/awstats /etc/awstats \

    && mv /etc/dovecot /vesta-start/etc/dovecot \
        && rm -rf /etc/
    && ln -s /vesta/etc/dovecot /etc/dov \

    && mv /etc/openvpn /vesta-start/etc/openvpn \
        && rm -rf /etc/ope
    && ln -s /vesta/etc/op \

    && mv /etc/mysql   /vesta \
    && rm -rf /etc/m

VOLUME ["/vesta", "/home", "/backup"]

EXPOSE 22 25 53 54 80 110 143 443 465 587 993 995 1194 3000 3306 5432 5984 6379 8083 10022 11211 27017
