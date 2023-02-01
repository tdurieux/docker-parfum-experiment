FROM tutum/lamp:latest

RUN a2enmod rewrite

#PHP dependencies
RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl php5-curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#NodeJS dependencies
RUN curl -f -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm config set prefix /usr/local
RUN npm install -g bower && npm cache clean --force;

#App setup
RUN rm -fr /app && git clone https://github.com/ranacseruet/codeigniterplus.git /app
ADD docker-files/makefile /app/makefile
RUN cd /app && make
ADD docker-files/database.php /app/application/config/database.php
ADD docker-files/run.sh /run.sh
ADD docker-files/.htaccess /app/.htaccess
ADD docker-files/create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

EXPOSE 80 3306
CMD ["/run.sh"]
