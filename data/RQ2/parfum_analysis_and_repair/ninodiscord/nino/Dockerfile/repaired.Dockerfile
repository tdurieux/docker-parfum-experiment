FROM node:16-alpine

LABEL MAINTAINER="Nino <cutie@floofy.dev>"
RUN apk update && apk add --no-cache git ca-certificates

WORKDIR /opt/Nino
COPY . .
RUN apk add --no-cache git
RUN npm i -g typescript eslint typeorm && npm cache clean --force;
RUN yarn
RUN yarn build:no-lint
RUN yarn cache clean

# Give it executable permissions
RUN chmod +x ./scripts/run-docker.sh

ENTRYPOINT [ "sh", "./scripts/run-docker.sh" ]
