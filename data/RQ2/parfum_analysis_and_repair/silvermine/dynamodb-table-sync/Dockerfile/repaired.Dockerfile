ARG NODE_JS_VERSION=12.14.0

FROM node:${NODE_JS_VERSION}-alpine

WORKDIR /opt/dynamodb-table-sync

COPY ./package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENTRYPOINT [ "node" ]

CMD [ "src/cli.js" ]
