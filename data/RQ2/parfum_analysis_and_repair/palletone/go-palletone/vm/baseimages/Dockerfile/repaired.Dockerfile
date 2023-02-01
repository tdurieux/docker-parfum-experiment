#基础镜像
FROM ubuntu:18.04

#维护者信息
MAINTAINER palletOne "contract@pallet.one"

#安装相应的软件
RUN apt-get -y update \
    && apt-get install --no-install-recommends -yqq wget \
       git \
       gcc && rm -rf /var/lib/apt/lists/*;
