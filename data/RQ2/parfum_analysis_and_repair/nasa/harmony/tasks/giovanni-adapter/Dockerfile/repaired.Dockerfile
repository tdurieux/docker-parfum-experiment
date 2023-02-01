FROM node:16-alpine

WORKDIR /app
COPY built package.json package-lock.json ./
RUN npm install --production && npm cache clean --force;

COPY config/giovanni-datafield.json /app/tasks/giovanni-adapter/config

ENTRYPOINT [ "node", "tasks/giovanni-adapter/app/cli" ]
