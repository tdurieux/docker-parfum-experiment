FROM openrasp/java7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

ENV jboss_url https://packages.baidu.com/app/jboss-5/jboss-5.0.1.GA.zip

# 下载JDK、Tomcat
RUN curl -f "$jboss_url" -o jboss.zip \
	&& unzip -q jboss.zip \
	&& rm -f jboss.zip \
	&& mv jboss-*/ /jboss/

# 其他配置
COPY start.sh /root/
COPY server.xml /jboss/server/default/deploy/jbossweb.sar/server.xml

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
EXPOSE 80
