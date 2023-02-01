FROM debian:wheezy
MAINTAINER Ahmed

RUN apt-get update && apt-get install -y apache2=2.2.22-13+deb7u13 chkconfig vim-tiny ca-certificates && apt-get remove -y vim-tiny && apt-get clean

RUN chkconfig apache2 on
RUN mkfifo /pipe
