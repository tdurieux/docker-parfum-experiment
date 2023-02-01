FROM node:12.14.0
WORKDIR /app
COPY package*.json ./
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org && npm cache clean --force;
RUN cnpm install
COPY ./ /app
EXPOSE 7001
RUN npm run start
