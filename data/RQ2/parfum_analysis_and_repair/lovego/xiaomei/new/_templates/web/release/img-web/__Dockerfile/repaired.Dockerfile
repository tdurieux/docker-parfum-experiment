# vim: ft=dockerfile:

FROM registry.cn-beijing.aliyuncs.com/lovego/service

LABEL builder=xiaomei

COPY web.conf /etc/nginx/sites-available/{{ .ProName }}.conf.tmpl
COPY public /var/www/{{ .ProName }}/

WORKDIR /var/log/nginx/{{ .ProName }}
USER root
RUN chown ubuntu:ubuntu .

CMD [ "nginx-start" ]