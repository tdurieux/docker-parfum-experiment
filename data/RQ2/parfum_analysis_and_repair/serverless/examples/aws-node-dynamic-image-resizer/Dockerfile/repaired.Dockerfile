FROM amazonlinux
WORKDIR /deploy
RUN yum -y install make gcc* && rm -rf /var/cache/yum
RUN curl -f --silent --location https://rpm.nodesource.com/setup_8.x | bash -
RUN yum -y install nodejs && rm -rf /var/cache/yum
RUN npm install -g serverless && npm cache clean --force;
COPY . .
RUN npm i --production && npm cache clean --force;

RUN ["chmod", "+x", "deploy.sh"]
CMD ./deploy.sh ; sleep 2m
