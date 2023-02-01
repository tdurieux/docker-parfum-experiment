FROM node:latest

WORKDIR /app/

RUN npm install cnpm -g --registry=https://registry.npm.taobao.org && npm cache clean --force;
#RUN npm install tyarn -g --registry=https://registry.npm.taobao.org

COPY ./ ./
COPY package.json ./

#RUN tyarn install
RUN cnpm install --silent --no-cache

#RUN tyarn global add pm2@latest
RUN cnpm install pm2@latest -g

RUN cnpm run build

CMD pm2 start --no-daemon -i 2 ./server/app.js
EXPOSE 3006
