#
# Dockerfile for mod_mruby on ubuntu 14.04 64bit
#

#
# Using Docker Image matsumotory/mod-mruby
#
# Pulling
#   docker pull matsumotory/mod-mruby
#
# Running
#  docker run -d -p 10080:80 matsumotory/mod-mruby
#
# Access
#   curl http://127.0.0.1:10080/mruby-hello
#

#
# Manual Build
#
# Building
#   docker build -t your_name:mod_mruby .
#
# Runing
#   docker run -d -p 10080:80 your_name:mod_mruby
#
# Access
#   curl http://127.0.0.1:10080/mruby-hello
#

FROM ubuntu:14.04
MAINTAINER matsumotory

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install sudo openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apache2 apache2-dev apache2-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install rake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ruby2.0 ruby2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libhiredis-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libmarkdown2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcap-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcgroup-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/src/ && git clone https://github.com/matsumoto-r/mod_mruby.git
RUN cd /usr/local/src/mod_mruby && sh build.sh && make install

EXPOSE 80
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

ADD docker/hook /etc/apache2/hook
ADD docker/conf/mruby.conf /etc/apache2/mods-available/mruby.conf
RUN cd /etc/apache2/mods-enabled && ln -s ../mods-available/mruby.conf mruby.conf

# sample check for now
RUN service apache2 restart && curl -f https://127.0.0.1/mruby-test && curl -f https://127.0.0.1/mruby-hello

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
