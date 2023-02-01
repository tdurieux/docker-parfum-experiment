FROM node:16

WORKDIR /server-express

COPY ./package.json .
RUN yarn && yarn cache clean;

COPY . .

ENTRYPOINT ["yarn", "prod"]