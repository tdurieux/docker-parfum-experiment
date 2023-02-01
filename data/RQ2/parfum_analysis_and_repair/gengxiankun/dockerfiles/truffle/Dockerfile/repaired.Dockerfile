FROM daocloud.io/library/centos:7.2.1511

RUN yum install -y epel-release &&\
	rpm -ivh https://kojipkgs.fedoraproject.org/packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm &&\
	yum -y install nodejs openssl &&\
	npm set registry https://registry.npm.taobao.org &&\
	npm set disturl https://npm.taobao.org/dist && \
	npm cache clean --force && \
	yum clean all && rm -rf /var/cache/yum

RUN npm install -g truffle && npm cache clean --force;

CMD ["/usr/sbin/init"]
