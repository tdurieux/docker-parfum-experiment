FROM docker.io/node:alpine
RUN apk add --no-cache git python3 build-base
COPY . /code
WORKDIR /code
RUN yarn install && yarn cache clean;
EXPOSE 3000
ENTRYPOINT ["yarn", "start"]
