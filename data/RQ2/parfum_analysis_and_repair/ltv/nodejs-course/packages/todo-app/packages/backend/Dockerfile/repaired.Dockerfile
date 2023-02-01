FROM node:12.16-alpine

WORKDIR /app/
ADD package.json .
RUN yarn install --production=true && yarn cache clean;
ADD src ./src

CMD [ "yarn", "start" ]
EXPOSE 3000
