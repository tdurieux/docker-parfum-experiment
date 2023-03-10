FROM openrasp/centos7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

# 安装 composer
RUN cd /tmp \
	&& curl -f https://packages.baidu.com/app/node-v8.5.0-linux-x64.tar.gz -o package.tar.gz \
	&& tar -xf package.tar.gz \
	&& rm -f package.tar.gz \
	&& mv node-v* /usr/local/nodejs \
	&& ln -sf /usr/local/nodejs/bin/node /usr/bin \
	&& ln -sf /usr/local/nodejs/bin/npm /usr/bin

RUN npm config set registry https://registry.npmmirror.com

# 其他配置
COPY start.sh /root/

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
EXPOSE 80
