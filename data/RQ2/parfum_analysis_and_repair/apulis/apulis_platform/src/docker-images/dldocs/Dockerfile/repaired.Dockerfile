FROM node:12

RUN mkdir -p /home/docs
WORKDIR /home/docs


ADD DLDocs/package.json .
# RUN yarn config set registry 'https://registry.npm.taobao.org'
RUN yarn && yarn cache clean;

COPY DLDocs/. /home/docs

RUN yarn en:build && yarn cache clean;
RUN yarn zh:build && yarn cache clean;

EXPOSE 3386

CMD ["node", "server.js"]