FROM node:lts-alpine3.9

WORKDIR /build
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

WORKDIR /app
RUN cp /build/src/global.json .
RUN cp /build/dist/webserver.js .

ENTRYPOINT [ "node", "webserver" ]