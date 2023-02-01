FROM centos:7

# Node install start

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

RUN yum install -y -q curl unzip bzip2 \
  && curl -f -sL https://rpm.nodesource.com/setup_14.x | bash - \
  && yum install -y nodejs \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && yum clean packages \
  && rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

ADD . /server
WORKDIR /server
RUN npm i --production && npm cache clean --force;
CMD ["node", "/server/index.js"]
