FROM centos:latest
LABEL maintainer="Animals4life"
RUN yum -y install httpd && rm -rf /var/cache/yum
COPY index.html /var/www/html/
COPY containerandcat*.jpg /var/www/html/
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80

