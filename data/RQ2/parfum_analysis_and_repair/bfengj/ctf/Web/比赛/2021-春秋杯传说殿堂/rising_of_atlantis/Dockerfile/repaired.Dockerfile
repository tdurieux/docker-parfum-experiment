FROM node:latest
COPY ./files /usr/local/app
WORKDIR /usr/local/app
RUN npm i --registry=https://registry.npm.taobao.org && npm cache clean --force;
COPY ./start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh