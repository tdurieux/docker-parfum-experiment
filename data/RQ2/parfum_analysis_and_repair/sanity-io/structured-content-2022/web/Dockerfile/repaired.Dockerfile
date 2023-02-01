FROM node:14

RUN mkdir /app
ADD . /app

WORKDIR /app
RUN yarn && yarn cache clean;

EXPOSE 3000

CMD ["yarn", "dev"]
