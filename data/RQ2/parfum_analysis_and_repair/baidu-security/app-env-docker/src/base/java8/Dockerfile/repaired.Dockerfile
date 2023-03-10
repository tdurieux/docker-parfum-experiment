FROM openrasp/centos7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

ENV install_url https://packages.baidu.com/app/jdk-8/jdk-8u72-linux-x64.tar.gz

RUN cd /tmp \
	&& curl -f "$install_url" -o package.tar.gz \
	&& tar -xf package.tar.gz \
	&& rm -f package.tar.gz \
	&& mv jdk1.8* /jdk/
