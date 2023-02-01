#Dockerfile
FROM centos:7

RUN curl -f -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install -y nodejs && rm -rf /var/cache/yum
RUN npm install -g canvas --unsafe-perm=true --allow-root && npm cache clean --force;
RUN npm install -g echarts --unsafe-perm=true --allow-root && npm cache clean --force;
RUN npm install -g formidable --unsafe-perm=true --allow-root && npm cache clean --force;


RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install supervisor && rm -rf /var/cache/yum

ENV NODE_PATH=/usr/lib/node_modules

EXPOSE 3000

RUN yum -y install fontconfig && rm -rf /var/cache/yum

RUN mkdir /usr/share/fonts/chinese

COPY SIMSUN.TTC /usr/share/fonts/chinese/SIMSUN.TTC

RUN chmod -R 755 /usr/share/fonts/chinese

RUN fc-cache -fv

COPY supervisord-nodejs.ini /etc/supervisord.d/supervisord-nodejs.ini

CMD /usr/bin/supervisord -n
#End
