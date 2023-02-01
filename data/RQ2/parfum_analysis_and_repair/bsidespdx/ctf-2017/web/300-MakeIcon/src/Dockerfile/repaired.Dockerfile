FROM python:2.7-slim
WORKDIR /
RUN apt-get update && apt-get install --no-install-recommends -y apache2 libapache2-mod-php5 php5 php-pear php5-xcache imagemagick && rm -rf /var/lib/apt/lists/*;
RUN rm /etc/ImageMagick-6/policy.xml
RUN rm /var/www/html/index.html
ADD index.php /var/www/html/
ADD flag /
EXPOSE 80

CMD ["/bin/bash","-c","/etc/init.d/apache2 start; while [ 1 ]; do sleep 3600; done"]
