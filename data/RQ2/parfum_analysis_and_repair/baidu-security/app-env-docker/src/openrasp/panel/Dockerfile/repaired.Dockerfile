FROM openrasp/java8

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

RUN useradd -m -s /bin/bash work

RUN cd / \
	&& curl -f https://packages.baidu.com/app/elk-5.6.8/elasticsearch-5.6.8.tar.gz -o elasticsearch-5.6.8.tar.gz \
	&& tar -xf elasticsearch-5.6.8.tar.gz \
	&& rm -f elasticsearch-5.6.8.tar.gz \
	&& mv /elasticsearch-*/ /elasticsearch/ \
	&& chown work -R /elasticsearch/

RUN cd / \
	&& curl -f https://packages.baidu.com/app/mongodb-linux-x86_64-3.6.9.tgz -o mongodb-linux-x86_64-3.6.9.tgz \
	&& tar -xf mongodb-linux-x86_64-3.6.9.tgz \
	&& rm -f mongodb-linux-x86_64-3.6.9.tgz \
	&& mv /mongodb-*/ /mongodb/ \
	&& mkdir /mongodb/data/ /mongodb/log/ \
	&& chown work -R /mongodb/

COPY app.conf *.sh /root/
RUN chmod +x /root/*.sh

ENTRYPOINT ["/root/start.sh"]
