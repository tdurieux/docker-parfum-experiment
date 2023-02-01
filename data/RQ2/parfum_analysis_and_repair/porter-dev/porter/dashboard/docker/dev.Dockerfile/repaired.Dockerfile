# Development environment
# -----------------------
FROM node:lts
WORKDIR /webpack

COPY package*.json ./

ENV NODE_ENV=development

RUN npm install && npm cache clean --force;
RUN npm i -g http-parser-js && npm cache clean --force;

COPY . ./

CMD npm start