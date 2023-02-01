FROM node:8.0.0

RUN echo "Asia/Shanghai" > /etc/timezone

RUN mkdir /app
WORKDIR /app

RUN npm install -g cnpm && npm cache clean --force;

COPY package.json /app
RUN cnpm install
