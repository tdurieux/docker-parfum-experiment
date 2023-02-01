FROM node:carbon

ENV NODE_ENV development

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN npm i && npm run build && npm cache clean --force;

EXPOSE 80
ENTRYPOINT [ "npm", "start" ]