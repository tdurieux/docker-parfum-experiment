FROM  node:14.16.1-slim
RUN npm install pm2 -g && npm cache clean --force;
COPY . /app
WORKDIR /app
RUN npm run bootstrap
RUN npm install --registry=https://registry.npm.taobao.org && npm cache clean --force;
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
EXPOSE 8014
EXPOSE 8015
CMD npm run prd