FROM  centos:centos7
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y nodejs && rm -rf /var/cache/yum
RUN yum install -y npm && rm -rf /var/cache/yum
RUN yum install -y redis && rm -rf /var/cache/yum
COPY . /SwarmESB
RUN cd /SwarmESB; npm install; npm cache clean --force; npm dedupe
RUN npm install http-server -g && npm cache clean --force;
EXPOSE  8000 8080
CMD ["/bin/bash", "/SwarmESB/container/start.sh"]









