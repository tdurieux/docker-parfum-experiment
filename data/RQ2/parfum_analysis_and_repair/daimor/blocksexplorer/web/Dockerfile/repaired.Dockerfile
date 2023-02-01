FROM node:12-slim

# RUN apk update && apk add git

WORKDIR /opt/app

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

ENV PATH="$PATH:./node_modules/.bin"

VOLUME /opt/app/node_modules
VOLUME /opt/app/build

CMD ["npm", "run", "serve:docker"]
