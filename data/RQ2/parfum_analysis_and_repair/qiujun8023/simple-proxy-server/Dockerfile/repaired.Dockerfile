FROM node:6.9.3
MAINTAINER qiujun i@qiujun.me

RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -q -g pm2 && pm2 dump && npm cache clean --force;

COPY . /app
WORKDIR /app
RUN npm install -q && npm cache clean --force;

EXPOSE 80 443

CMD ["pm2", "start", "pm2.json", "--no-daemon"]
