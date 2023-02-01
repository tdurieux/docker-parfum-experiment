FROM centos:7

RUN yum update -y && yum install -y epel-release && rm -rf /var/cache/yum

RUN yum install -y nginx supervisor && rm -rf /var/cache/yum

RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisord.conf

COPY nginx_status.conf /etc/nginx/conf.d/

COPY nginx_exporter /bin

EXPOSE 80 9113

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
