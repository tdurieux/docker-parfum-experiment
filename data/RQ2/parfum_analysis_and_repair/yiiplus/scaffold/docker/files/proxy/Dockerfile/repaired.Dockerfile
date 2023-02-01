FROM centos:7.2.1511

RUN yum install -y epel-release &&\
    rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm && \
    yum install -y --enablerepo=remi readline-devel pcre-devel openssl-devel perl wget gcc make && rm -rf /var/cache/yum

RUN wget https://openresty.org/download/openresty-1.11.2.3.tar.gz &&\
    tar xzvf openresty-1.11.2.3.tar.gz &&\
    cd openresty-1.11.2.3 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/openresty \
             --with-luajit \
             --without-http_redis2_module \
             --with-http_iconv_module && \
    make && make install && \
    ln -s /opt/openresty/nginx/conf /etc/nginx && ln -s /opt/openresty/nginx/sbin/nginx /usr/local/bin/ && \
    sed -i  "34a\    include /etc/nginx/conf.d/*.conf;" /etc/nginx/nginx.conf && rm openresty-1.11.2.3.tar.gz

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 80 443

CMD ["docker-entrypoint.sh"]

