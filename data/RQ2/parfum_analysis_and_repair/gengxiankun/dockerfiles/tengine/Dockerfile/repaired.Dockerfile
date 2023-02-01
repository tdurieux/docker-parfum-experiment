FROM centos:7.2.1511
RUN cd /usr/ &&\
	yum install -y wget tar gcc pcre-devel openssl openssl-devel && \
	wget https://tengine.taobao.org/download/tengine-2.2.0.tar.gz && \
	tar zxvf tengine-2.2.0.tar.gz && \
	cd tengine-2.2.0 && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-http_upstream_check_module && \
	make && \
	make install && \
	ln -s /usr/local/nginx/conf/ /etc/nginx && rm -rf /var/cache/yum

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 80

CMD ["docker-entrypoint.sh"]