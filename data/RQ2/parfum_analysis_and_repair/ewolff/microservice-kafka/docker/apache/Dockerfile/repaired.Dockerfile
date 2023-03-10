FROM ubuntu:20.04

# Update Ubuntu
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install --no-install-recommends -y -qq apache2 && \
    a2enmod proxy proxy_http proxy_ajp rewrite deflate headers proxy_connect proxy_html lbmethod_byrequests && \
    mkdir /var/lock/apache2 && mkdir /var/run/apache2 && rm -rf /var/lib/apt/lists/*; # Install Apache + modules




# Config Apache
COPY index.html /var/www/html/index.html
COPY 000-default.conf  /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
CMD apache2ctl -D FOREGROUND
