FROM node:erbium

RUN mkdir -p /app/yearn-finance
WORKDIR /app/yearn-finance
ADD . /app/yearn-finance
RUN yarn install && yarn cache clean;

ENTRYPOINT ["yarn", "dev"]
