FROM openrasp/java7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

ENV resin_url https://packages.baidu.com/app/resin-4/resin-4.0.58.zip

# 下载
RUN curl -f "$resin_url" -o package.zip \
	&& unzip -qq package.zip \
	&& rm -f package.zip \
	&& mv resin-4*/ /resin/

# 其他配置
COPY start.sh /root/
COPY resin.conf /resin/conf/resin.conf

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
EXPOSE 80
