FROM node:10

WORKDIR /3box-js

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

COPY src ./src
COPY webpack*.config.js .babelrc ./
COPY example ./example

EXPOSE 30000

CMD npm run example-server:start | npm run build:dist:dev
