FROM ubuntu-upstart:precise
MAINTAINER Ahmed

# dpkg-divert - https://github.com/docker/docker/issues/1024#issuecomment-20018600
RUN mv /sbin/initctl /sbin/initctl.orig && \
    ln -s /bin/true /sbin/initctl && \
    apt-get update && \
    apt-get install -y apache2=2.2.22-1ubuntu1.11 chkconfig vim-tiny autofs && \
    apt-get remove -y vim-tiny && \
    apt-get clean && \
    rm -f /sbin/initctl && \
    mv /sbin/initctl.orig /sbin/initctl && \
    echo manual > /etc/init/apache2.override

RUN chkconfig apache2 on
RUN mkfifo /pipe
