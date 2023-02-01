FROM node:9.5.0

RUN mkdir -p /src

COPY . /src

WORKDIR /src

RUN yarn install && yarn cache clean;
RUN yarn build

ENV PORT 3001
EXPOSE $PORT

CMD ["yarn", "start"]