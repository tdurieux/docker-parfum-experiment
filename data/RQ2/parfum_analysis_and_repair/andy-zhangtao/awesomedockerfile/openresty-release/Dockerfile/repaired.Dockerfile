FROM    centos:7
LABEL   maintainer ztao8607@gmail.com

COPY    OpenResty.repo /etc/yum.repos.d/OpenResty.repo

RUN yum install -y openresty && rm -rf /var/cache/yum

RUN     rm -f /usr/local/openresty/nginx/logs/error.log && \
        rm -f /usr/local/openresty/nginx/logs/access.log && \
        ln -s /dev/stdout /usr/local/openresty/nginx/logs/access.log && \
        ln -s /dev/stdout /usr/local/openresty/nginx/logs/error.log

CMD     ["openresty"]
