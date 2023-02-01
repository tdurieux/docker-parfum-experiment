FROM node:6.2-slim

RUN mkdir -p /app
WORKDIR /app

RUN npm install -g nodemon && npm cache clean --force;

ENV NODE_ENV development

EXPOSE 8888

CMD npm run watch
