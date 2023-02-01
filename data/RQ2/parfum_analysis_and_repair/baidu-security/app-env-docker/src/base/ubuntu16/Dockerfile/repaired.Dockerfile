FROM ubuntu:16.04

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

COPY sources.list /etc/apt/sources.list

# 安装软件
RUN apt update \
	&& apt install --no-install-recommends -y vim nano wget curl lrzsz python-requests git python-pip \
	&& apt clean all && rm -rf /var/lib/apt/lists/*;

# 其他配置
COPY *.sh .bash* .vimrc /root/

ENTRYPOINT ["/bin/bash"]
