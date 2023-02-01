FROM node:15.14.0-alpine3.10
WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;
RUN npm run build

EXPOSE 3000
CMD [ "node", "dist/index.js", "server" ]