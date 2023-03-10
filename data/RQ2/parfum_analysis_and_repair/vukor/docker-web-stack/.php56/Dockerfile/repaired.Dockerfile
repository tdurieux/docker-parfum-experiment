## Version: 0.3
FROM centos:centos6
MAINTAINER Anton Bugreev <anton@bugreev.ru>

## Import centos 6 base key
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

## Install epel repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && \
    yum install ansible1.9 git -y && rm -rf /var/cache/yum

## Deploy php 5.6 role with ansible, we using ansible in prod - not yet docker
RUN cd /tmp/ && \
    git clone https://github.com/vukor/ansible-deploy-web-stack && \
    cd /tmp/ansible-deploy-web-stack/ && \
    echo 'local' >> inventory/hosts && \
    sed -i 's/prj_group: www/prj_group: dev/' inventory/group_vars/all.yml && \
    ansible-playbook playbook/setup.yml -t unix,remi,user,php --connection=local && \
    cd / && rm -rf /tmp/ansible-deploy-web-stack/
#    echo 'clean_requirements_on_remove=1' >> /etc/yum.conf && \
#    yum remove ansible git epel-release -y && \
#    yum clean all

## DEBUG!
## build, configure libiconv 1.x (needs for php)
RUN yum install tar gcc wget -y && \
    cd /tmp && \
    wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz && \
    tar -xvzf ./libiconv-1.14.tar.gz && \
    cd ./libiconv-1.14/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && \
    make && make install && \
    cd /tmp && rm -rf /tmp/libiconv* && \
    echo "export LD_PRELOAD=/usr/local/lib/preloadable_libiconv.so" >> /etc/bashrc && rm -rf /var/cache/yum
RUN yum --enablerepo=remi-php56 install php-pear php-devel -y && \
    pecl install xdebug && rm -rf /var/cache/yum

### Copy configs
COPY ./etc/php-fpm.conf /etc/php-fpm.conf
COPY ./etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf
COPY ./etc/php.ini /etc/php.ini

## Install test
COPY tests /tests

### volumes
## php-fpm
VOLUME ["/etc/php-fpm.d/"]

## web
VOLUME ["/home/dev/logs/"]
VOLUME ["/home/dev/htdocs/"]

## allow ports
EXPOSE 9000

