# -------------------------------------------------------------------------------
# Filename:     Dockerfile
# UpdateDate:   2022/03/18
# Description:  Build docker images for YOLOv5.
# Example:
# Depends:      Based on Ubuntu 16.04
# Notes:
# -------------------------------------------------------------------------------
FROM ubuntu:18.04
MAINTAINER CambriconKnight <cambricon_knight@163.com>

# 1.Sync files
RUN echo -e 'nameserver 114.114.114.114' > /etc/resolv.conf
COPY ./docker/* /temp/
WORKDIR /temp/

# 2.Pre-installed software
ENV DEBIAN_FRONTEND=noninteractive
RUN bash ./pre_packages.sh

# 3.Set ENV && Clean
ENV LANG C.UTF-8
ENV TIME_ZONE Asia/Shanghai
RUN echo "${TIME_ZONE}" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    rm -rf /temp/ && rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# 4.Set WorkDir