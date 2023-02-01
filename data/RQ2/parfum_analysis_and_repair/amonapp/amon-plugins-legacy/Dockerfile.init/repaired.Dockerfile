FROM phusion/baseimage:latest
MAINTAINER Martin Rusev

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv AD53961F

RUN echo 'deb http://bg.archive.ubuntu.com/ubuntu trusty main universe' > /etc/apt/sources.list && \
    echo 'deb http://bg.archive.ubuntu.com/ubuntu trusty-updates main restricted' >> /etc/apt/sources.list && \
    echo 'deb http://bg.archive.ubuntu.com/ubuntu trusty-security main' >> /etc/apt/sources.list

RUN echo 'deb http://packages.amon.cx/repo amon contrib' >> /etc/apt/sources.list
RUN apt-get update


RUN apt-get install --no-install-recommends software-properties-common -y --force-yes && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get install --no-install-recommends ansible mysql-server apache2 nginx postgresql mongodb-server -y --force-yes && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]