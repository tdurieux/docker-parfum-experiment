FROM node:16-alpine

RUN mkdir /app
WORKDIR /app

COPY . /app
RUN apk add --no-cache --update python gcc g++ make && \
    yarn install --frozen-lockfile && yarn cache clean;

CMD ["yarn", "dev"]
