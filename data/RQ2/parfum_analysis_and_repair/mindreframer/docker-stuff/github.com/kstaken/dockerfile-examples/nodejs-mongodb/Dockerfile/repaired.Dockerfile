FROM ubuntu
MAINTAINER Kimbro Staken

RUN apt-get install --no-install-recommends -y python-software-properties python python-setuptools ruby rubygems && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/node.js
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install mongodb-10gen && rm -rf /var/lib/apt/lists/*;

RUN easy_install supervisor
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN printf "[include]\nfiles = /var/www/Supervisorfile\n" >> /etc/supervisord.conf

ADD . /var/www

RUN cd /var/www ; npm install && npm cache clean --force;

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]