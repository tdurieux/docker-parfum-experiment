FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y xinetd libc6-i386 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN useradd -M --shell /bin/false getflag && \
    useradd -M oil

RUN echo "oil - nproc 1000" > /etc/security/limits.d/oil.conf && \
    echo "getflag - nproc 1000" > /etc/security/limits.d/getflag.conf


RUN mkdir /chroot
WORKDIR /chroot

RUN mkdir -p ./home/oil/

RUN echo "cd /home/oil/ && ./oil" >./start.sh && \
    chmod 555 ./start.sh


RUN cp -R /lib* . && \
    cp -R /usr/lib* .

RUN mkdir ./dev && \
    mknod ./dev/null c 1 3 && \
    mknod ./dev/zero c 1 5 && \
    mknod ./dev/random c 1 8 && \
    mknod ./dev/urandom c 1 9 && \
    chmod 666 ./dev/*

RUN mkdir ./bin/ && \
    cp /bin/sh ./bin/ && \
    cp /bin/ls ./bin/ && \
    cp /bin/cat ./bin/ && \
    cp /bin/pwd ./bin/ && \
    cp /usr/bin/whoami ./bin/ && \
    ln -s /bin/sh ./bin/bash

RUN mkdir ./etc/ && \
    cp /etc/passwd ./etc/

RUN chown -R root:root .


COPY ./getflag/getflag ./home/oil/
RUN chown -R getflag:getflag ./home/oil/getflag && \
    chmod 111 ./home/oil/getflag && \
    chmod +s ./home/oil/getflag

COPY ./getflag/tokens ./etc/tokens
RUN chown -R root:getflag ./etc/tokens && \
    chmod 440 ./etc/tokens

COPY ./service/oil ./home/oil/
RUN chmod 111 ./home/oil/oil


COPY ./oil.xinetd /etc/xinetd.d/oil
COPY ./xinetd_start.sh /xinetd_start.sh

RUN chmod 400 /etc/xinetd.d/oil && \
    chmod 100 /xinetd_start.sh


CMD ["/xinetd_start.sh"]

EXPOSE 9999
