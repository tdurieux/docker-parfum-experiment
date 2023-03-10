# Pull base image
FROM ubuntu:trusty

MAINTAINER image "malingtao1019@163.com" 
# update source 
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe"> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y mysql-server apache2 php5 php5-mysql && rm -rf /var/lib/apt/lists/*;

COPY database.sql /root/
RUN /etc/init.d/mysql start &&\
    mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'toor';"&&\
    mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by 'toor';"&&\
    mysql -u root -ptoor -e "show databases;" &&\
    mysql -u root -ptoor </root/database.sql &&\
	mysql -u root -ptoor -e "show databases;"

RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
	&& echo 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
	&& mv /tmp/my.cnf /etc/mysql/my.cnf

COPY . /var/www/html/
RUN rm /var/www/html/index.html \
	&& rm /var/www/html/Dockerfile \
	&& rm /var/www/html/database.sql \
	&& rm /var/www/html/httpd-foreground \
	&& chown www-data:www-data /var/www/html -R \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
COPY httpd-foreground /usr/bin
EXPOSE 80
CMD ["httpd-foreground"]

