FROM mozillamarketplace/centos-python27-mkt:latest

RUN yum install -y npm && rm -rf /var/cache/yum

RUN npm install -g grunt-cli && npm cache clean --force;
