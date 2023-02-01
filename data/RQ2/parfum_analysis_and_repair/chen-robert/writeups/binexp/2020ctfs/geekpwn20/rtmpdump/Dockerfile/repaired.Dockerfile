FROM centos:7

RUN yum -y install cronie openssl-devel zlib gcc make && rm -rf /var/cache/yum
RUN curl -f https://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz > rtmpdump.tgz && \
    tar xvzf rtmpdump.tgz && cd rtmpdump-2.3/ && \
    make && make install && rm rtmpdump.tgz

CMD crond && rtmpsrv -z
