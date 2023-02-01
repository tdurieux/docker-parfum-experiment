FROM dockersecplayground/vulnerable_lamp

RUN wget https://www.exploit-db.com/apps/1d66967de30d1aa867c96a6d6b80d302-Persian-VIP.zip && unzip 1d66967de30d1aa867c96a6d6b80d302-Persian-VIP.zip && rm -rf /var/www/* && mv  Persian*/* /var/www/ && chown -R www-data:www-data  /var/www/* 
COPY config.php /var/www/config.php
COPY persian.sql /persian.sql 
RUN service mysql restart &&  mysql -uroot -pAdmin2015 -e "create database persian"   &&  mysql -uroot -pAdmin2015   persian < /persian.sql