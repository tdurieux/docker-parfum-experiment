FROM centos:7.2.1511

# 初始设置
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&\
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm &&\
    yum makecache &&\  
    yum install -y vim tar wget curl bzip2 net-tools lsof sysstat cronie python-setuptools &&\
    yum install php72w php72w-cli php72w-common php72w-fpm php72w-bcmath php72w-gd php72w-mbstring php72w-pdo php72w-mysqlnd php72w-mcrypt nginx1w -y &&\
    yum install perl perl-Data-Dumper libaio* libnuma* -y  &&\
    yum install redis -y &&\
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/* &&\    
    easy_install supervisor && \
    cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && rm -rf /var/cache/yum

# 安装软件
#RUN yum clean all &&\
#    yum install epel-release -y &&\
#    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&\
#    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm &&\
#    yum makecache &&\
#    yum install php72w php72w-common php72w-fpm php72w-bcmath php72w-gd php72w-mbstring php72w-pdo php72w-mysqlnd nginx1w -y &&\
#    yum install perl perl-Data-Dumper libaio* libnuma* -y  &&\
#    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

ENV fpm_conf /etc/php-fpm.d/www.conf
ENV php_ini /etc/php.ini

#copy nginx-site
#RUN rm -Rf  /usr/local/nginx/conf/vhosts/* && rm -Rf /usr/local/nginx/conf/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/php_fcgi.conf /etc/nginx/php_fcgi.conf
ADD conf/pathinfo.conf /etc/nginx/pathinfo.conf
ADD conf/nginx-site.conf /etc/nginx/conf.d/nginx-site.conf

#copy swoole-loader
ADD deploy/swoole_loader72.so /usr/lib64/php/modules/swoole_loader72.so
# ADD deploy/libsodium.so.23 /usr/lib64/libsodium.so.23
ADD conf/swoole_loader.ini /etc/php.d/swoole_loader.ini


# tweak php-fpm & php-ini & zend config
RUN adduser www &&\
    sed -i \        
    -e "s/pm = dynamic/pm = static/g" \    
    -e "s/pm.max_children = 50/pm.max_children = 5/g" \    
    -e "s/user = apache/user = www/g" \   
    -e "s/group = apache/group = www/g" \  
    ${fpm_conf}  &&\
    sed -i \
    -e "s/post_max_size = 8M/post_max_size = 50M/g" \    
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 50M/g" \  
    ${php_ini}




#ADD link
#RUN ln -s /usr/local/php56/bin/php /usr/local/bin/php &&\
#ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx


#copy supervisord
RUN rm -Rf /etc/supervisord.conf
ADD conf/supervisord.conf /etc/supervisord.conf



# Add Scripts
RUN rm -Rf /start.sh
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh && chown -Rf www.www /var/lib/nginx

# 安装mysql（选填）
#RUN yum clean all &&\   
#    yum install  mysql56  &&\
#    rm -rf /data/mysql/3306/ib* /data/mysql/3306/*-bin.* /data/mysql/3306/test &&\
#    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/* &&\
#    rm -Rf /usr/local/mysql/my.cnf
#ADD conf/my.cnf /usr/local/mysql/my.cnf

# copy in code
#RUN rm -Rf /data/httpd/*
#ADD httpd.tar /data/
#VOLUME /data/httpd

#EXPOSE 443 80 22
EXPOSE 80

CMD ["/start.sh"]

