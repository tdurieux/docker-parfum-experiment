FROM node:10 AS build-env
WORKDIR /app
COPY package-lock.json package.json ./
RUN npm install && npm cache clean --force;
COPY . /app

FROM registry.cn-hangzhou.aliyuncs.com/liguobao/house-map:nodejs-base
COPY --from=build-env /app /app
EXPOSE 3000
CMD ["/app/app.js"]

