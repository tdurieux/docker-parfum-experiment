FROM  centos:centos7
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN curl -f --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum install -y nodejs && rm -rf /var/cache/yum
#RUN node --version
#RUN   yum install -y npm
RUN yum install -y redis && rm -rf /var/cache/yum
COPY . /op-sharedbus
RUN cd /op-sharedbus; npm install; npm cache clean --force; npm dedupe
RUN npm install http-server -g && npm cache clean --force;
EXPOSE 8080 
CMD ["/bin/bash", "/op-sharedbus/container/start.sh"]









