FROM node:18

WORKDIR /opt/my/service

COPY . /opt/my/service

RUN yarn install && yarn cache clean;

EXPOSE 1300

ENTRYPOINT ["node", "/opt/my/service/server.js"]
