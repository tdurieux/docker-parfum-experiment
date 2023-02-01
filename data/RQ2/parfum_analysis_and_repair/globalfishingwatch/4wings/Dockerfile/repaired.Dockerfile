FROM node:12.3-alpine
RUN apk update && apk upgrade && apk add --no-cache git && mkdir /opt/project
WORKDIR /opt/project
COPY package.json package.json
RUN npm install && npm cache clean --force;
COPY src src
COPY tsconfig.json tsconfig.json
COPY tslint.json tslint.json
COPY index.js index.js

ENTRYPOINT ["node", "--max-http-header-size=80000", "--max-old-space-size=5120", "index"]


