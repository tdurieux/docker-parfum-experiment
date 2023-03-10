FROM node:14-alpine3.12
WORKDIR /usr/src/app/
COPY . .
RUN yarn install && yarn cache clean;
USER node
ENTRYPOINT [ "yarn", "start" ]
