FROM mhart/alpine-node

LABEL author="doramart@qq.com"

ENV PORT=8080

WORKDIR /app
COPY . /app

RUN npm install --registry=https://registry.npm.taobao.org && npm cache clean --force;
RUN npm install mammoth node-schedule --registry=https://registry.npm.taobao.org && npm cache clean --force;

EXPOSE ${PORT}


CMD BUILD_ENV=docker npm run dev

