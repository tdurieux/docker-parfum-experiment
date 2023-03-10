FROM ubuntu:bionic
MAINTAINER peter.ebden@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y nginx-extras && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/www/data && chown www-data /var/www/data
COPY /webdav.conf /etc/nginx/conf.d/webdav.conf
CMD [ "nginx", "-g", "daemon off;" ]
EXPOSE 8080/tcp
VOLUME /var/www/data
