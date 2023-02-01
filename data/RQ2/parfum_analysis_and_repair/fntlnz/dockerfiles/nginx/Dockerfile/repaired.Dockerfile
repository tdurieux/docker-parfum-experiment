# This is just a template
# To build use the build.sh script
FROM centos:centos7

MAINTAINER Lorenzo Fontana, fontanalorenzo@me.com

WORKDIR /tmp
RUN yum install -y gcc gcc-c++ make zlib pcre openssl zlib-devel pcre-devel openssl-devel wget telnet tar \
    && wget -nv -O - https://nginx.org/download/nginx-VERSION.tar.gz | tar zx \
    && cd nginx-VERSION \
    && CONFIGURE_COMMAND \
    && make -j \
    && make install \
    && rm -Rf /tmp/nginx* \
    && yum remove -y gcc gcc-c++ make zlib-devel pcre-devel openssl-devel wget telnet tar \
    && yum clean all && rm -rf /var/cache/yum

WORKDIR /

# Add nginx user
RUN useradd nginx

ENTRYPOINT [ "/usr/local/nginx/sbin/nginx", "-g", "daemon off;" ]

EXPOSE 80
EXPOSE 443
