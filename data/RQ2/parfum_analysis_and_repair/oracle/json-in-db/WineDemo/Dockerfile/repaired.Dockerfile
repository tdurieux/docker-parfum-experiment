FROM oraclelinux:7.6

COPY . /app

RUN yum install -y oracle-release-el7 && rm -rf /var/cache/yum
RUN yum install -y oracle-instantclient19.3-basic.x86_64 && rm -rf /var/cache/yum
RUN yum install -y oracle-nodejs-release-el7 && rm -rf /var/cache/yum
RUN yum install -y --disablerepo=ol7_developer_EPEL nodejs && rm -rf /var/cache/yum
RUN yum install -y bzip2 && rm -rf /var/cache/yum

RUN npm -g install @oracle/ojet-cli && npm cache clean --force;
RUN npm -g install pm2 && npm cache clean --force;

RUN cd /app && npm install && ojet build && npm cache clean --force;

CMD ["pm2-runtime", "/app/process.json"]
