FROM node:slim
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org && cnpm install -g webpack && npm cache clean --force;
WORKDIR /app
COPY ./package.json .
RUN cnpm install
COPY . .
RUN npm run build
ENTRYPOINT ["node","./server/index.js"]

