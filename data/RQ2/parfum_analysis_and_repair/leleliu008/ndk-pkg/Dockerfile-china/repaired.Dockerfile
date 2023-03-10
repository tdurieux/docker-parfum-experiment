FROM ubuntu:22.04

MAINTAINER leleliu008@gmail.com

ADD bin/ndk-pkg /usr/bin/

RUN sed -i "s@archive.ubuntu.com@mirrors.aliyun.com@g" /etc/apt/sources.list && \
    sed -i "s@security.ubuntu.com@repo.huaweicloud.com@g" /etc/apt/sources.list

ENTRYPOINT [ "/bin/bash", "-l" ]