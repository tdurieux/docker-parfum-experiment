FROM node:12

RUN mkdir -p /home/handbook
WORKDIR /home/handbook


ADD package.json .
RUN yarn config set registry 'https://registry.npm.taobao.org' && yarn cache clean;
RUN yarn && yarn cache clean;

COPY . /home/handbook

RUN yarn en:build && yarn cache clean;
RUN yarn zh:build && yarn cache clean;

EXPOSE 3386

CMD ["node", "server.js"]