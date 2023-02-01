# 基于 node 镜像

FROM node
RUN rm -rf /www
RUN mkdir /www
WORKDIR /www

COPY . /www
RUN npm install && npm cache clean --force;
RUN npm i -g pm2 && npm cache clean --force;
EXPOSE 9000
CMD pm2 start bin/init.js --name web-monitoring/backend_server_docker --no-daemon