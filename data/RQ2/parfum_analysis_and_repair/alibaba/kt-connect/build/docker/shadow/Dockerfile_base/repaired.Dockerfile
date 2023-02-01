FROM ubuntu:22.04

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y openssh-server dnsutils iputils-ping net-tools iproute2 curl lsof && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd && \
    # SSH login fix. Otherwise user is kicked off after login
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY build/docker/shadow/sshd_config /etc/ssh/sshd_config
RUN chmod +rw /etc/ssh/sshd_config

EXPOSE 22
