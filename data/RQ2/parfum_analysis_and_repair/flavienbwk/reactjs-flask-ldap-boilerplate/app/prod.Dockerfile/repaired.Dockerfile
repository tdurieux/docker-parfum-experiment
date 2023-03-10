FROM node:13.0.1-alpine

ARG NODE_ENV

COPY ./app /app

WORKDIR '/app'
RUN npm install && npm cache clean --force;
RUN npm run build --production

RUN npm install -g serve && npm cache clean --force;

EXPOSE 3000
ENTRYPOINT ["serve", "-l", "tcp://0.0.0.0:3000", "-s", "/app/build"]
