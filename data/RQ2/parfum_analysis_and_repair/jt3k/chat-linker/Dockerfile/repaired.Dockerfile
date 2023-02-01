FROM node:8.7.0-alpine
WORKDIR /usr/app

RUN apk update && apk add --no-cache git
COPY . /usr/app

RUN npm install && npm cache clean --force;
RUN npm run build # TODO: Not stable enough; migrate to yarn

ENV NODE_ENV prod
CMD ["node", "dist/app.js"]
