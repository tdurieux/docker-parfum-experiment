FROM node:12.13.0-alpine as builder

RUN npm install -g typescript && npm cache clean --force;

WORKDIR /usr/local/src
COPY package.json .
RUN npm install --only=production && npm cache clean --force;
COPY . .
RUN npm run build

FROM node:12.13.0-alpine
WORKDIR /usr/local/src
COPY --from=builder /usr/local/src/dist  /usr/local/src/dist
COPY --from=builder /usr/local/src/node_modules  /usr/local/src/node_modules
COPY --from=builder /usr/local/src/package.json  /usr/local/src/package.json
COPY --from=builder /usr/local/src/package-lock.json  /usr/local/src/package-lock.json

CMD [ "npm","run","start" ]
