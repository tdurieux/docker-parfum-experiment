# Pull base image
FROM ubuntu:trusty

MAINTAINER image "malingtao1019@163.com" 
# update source 
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe"> /etc/apt/sources.list 
RUN apt-get update \
	&& apt-get install --no-install-recommends -y apache2 php5 && rm -rf /var/lib/apt/lists/*;

COPY src /var/www/html
RUN rm /var/www/html/index.html &&\
 chown www-data:www-data /var/www/html -R
COPY httpd-foreground /usr/bin
EXPOSE 80
CMD ["httpd-foreground"]
