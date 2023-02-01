FROM node:11

RUN npm install -g dockerfilelint && npm cache clean --force;

WORKDIR /.docker-lint-action

COPY entrypoint.sh package.json package-lock.json ./

RUN npm install && npm cache clean --force;

COPY build build

ENTRYPOINT [ "/.docker-lint-action/entrypoint.sh" ]