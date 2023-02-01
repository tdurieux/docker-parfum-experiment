FROM centos:latest
RUN yum -y install httpd && rm -rf /var/cache/yum
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80
