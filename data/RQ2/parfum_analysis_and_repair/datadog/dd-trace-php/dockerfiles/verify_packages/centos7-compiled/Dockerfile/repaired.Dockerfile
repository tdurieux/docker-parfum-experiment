FROM centos:7

RUN yum update -y

RUN yum install autoconf libtool re2c bison libxml2-devel bzip2-devel libcurl-devel libpng-devel libicu-devel gcc-c++ libmcrypt-devel libwebp-devel libjpeg-devel openssl-devel -y && rm -rf /var/cache/yum
RUN mkdir -p /src/php;( cd /src/php; curl -f -L https://github.com/php/php-src/archive/php-7.1.9.tar.gz | tar --strip-component=1 -zx)
WORKDIR /src/php
RUN yum -y install make gcc && rm -rf /var/cache/yum

RUN ./buildconf --force && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-curl --with-openssl
RUN make && make install

RUN php --ini
RUN yum install -y vim valgrind && rm -rf /var/cache/yum


ADD build/packages /packages
RUN rpm -ivh /packages/*.rpm

RUN php -m | grep ddtrace

CMD ["bash"]

ENTRYPOINT ["/bin/bash", "-c"]
