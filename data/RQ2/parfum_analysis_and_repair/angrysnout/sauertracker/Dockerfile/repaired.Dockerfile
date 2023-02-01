FROM node:13

WORKDIR /usr/src/app

COPY package*.json ./

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

EXPOSE 8080

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "start" ]
