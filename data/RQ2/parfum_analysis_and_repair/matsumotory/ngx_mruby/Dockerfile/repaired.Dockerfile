#
# Dockerfile for ngx_mruby on ubuntu 18.04 64bit
#

#
# Using Docker Image matsumotory/ngx-mruby
#
# Pulling
#   docker pull matsumotory/ngx-mruby
#
# Running
#  docker run -d -p 10080:80 matsumotory/ngx-mruby
#
# Access
#   curl http://127.0.0.1:10080/mruby-hello
#

#
# Manual Build
#
# Building
#   docker build -t your_name:ngx_mruby .
#
# Runing
#   docker run -d -p 10080:80 your_name:ngx_mruby
#
# Access
#   curl http://127.0.0.1:10080/mruby-hello
#

FROM ubuntu:18.04
MAINTAINER matsumotory

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install sudo openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install rake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcurl4-openssl-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libhiredis-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libmarkdown2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcap-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcgroup-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpcre3 libpcre3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/src/ && git clone https://github.com/matsumotory/ngx_mruby.git
ENV NGINX_CONFIG_OPT_ENV --with-http_stub_status_module --with-http_ssl_module --prefix=/usr/local/nginx --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module
RUN cd /usr/local/src/ngx_mruby && sh build.sh && make install

EXPOSE 80
EXPOSE 443

ONBUILD ADD docker/hook /usr/local/nginx/hook
ONBUILD ADD docker/conf /usr/local/nginx/conf
ONBUILD ADD docker/conf/nginx.conf /usr/local/nginx/conf/nginx.conf

CMD ["/usr/local/nginx/sbin/nginx"]
