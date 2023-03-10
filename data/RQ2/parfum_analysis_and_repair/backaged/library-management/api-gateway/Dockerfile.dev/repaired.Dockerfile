# Development image not for production
FROM node:10-slim

WORKDIR /server

COPY . .

RUN yarn install && yarn cache clean;

EXPOSE 3000
CMD [ "yarn", "dev" ]

#ENTRYPOINT ["node dist/index.js"]