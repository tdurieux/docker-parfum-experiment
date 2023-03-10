FROM debian:wheezy
MAINTAINER Ahmed

RUN echo 'deb http://archive.debian.org/debian wheezy main' > /etc/apt/sources.list
RUN echo 'deb http://archive.debian.org/debian-security wheezy/updates main' >> /etc/apt/sources.list

RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install --no-install-recommends -y apache2 apache2-doc apache2-utils chkconfig vim-tiny ca-certificates tinyproxy && apt-get remove -y vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN chkconfig apache2 on
RUN chkconfig tinyproxy on
RUN mkfifo /pipe
