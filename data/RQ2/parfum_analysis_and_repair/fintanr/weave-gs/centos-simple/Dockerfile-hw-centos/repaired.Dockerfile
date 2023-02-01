FROM    centos
MAINTAINER      fintan@weave.works
RUN yum install -y httpd && rm -rf /var/cache/yum
RUN yum install -y php && rm -rf /var/cache/yum
ADD     example/index.php /var/www/html/
ADD     example/run-httpd.sh /run-httpd.sh
RUN     chmod -v +x /run-httpd.sh
CMD     ["/run-httpd.sh"]
