FROM node:lts-alpine

WORKDIR /usr/src/app
ENV TZ=Asia/Shanghai

COPY . .

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD ["node", "./build/server.js"]

EXPOSE 8080