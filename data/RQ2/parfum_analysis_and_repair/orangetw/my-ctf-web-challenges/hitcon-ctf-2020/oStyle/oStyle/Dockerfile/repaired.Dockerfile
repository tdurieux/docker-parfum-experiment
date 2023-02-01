FROM ubuntu:latest
EXPOSE 80
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y apache2 libapache2-mod-php7.4 python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir rq
RUN a2enmod headers
RUN mkdir /var/www/html/upload && chmod 777 /var/www/html/upload/
RUN rm /var/www/html/index.html

ADD my_security.conf /etc/apache2/mods-enabled/
ADD config.json /
ADD www/*   /var/www/html/

CMD ["sh", "-c", "service apache2 start && tail -f /var/log/apache2/error.log"]