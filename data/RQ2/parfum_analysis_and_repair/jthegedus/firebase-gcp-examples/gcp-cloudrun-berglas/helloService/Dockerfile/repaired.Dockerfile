FROM node:10-alpine

RUN apk add --no-cache ca-certificates

ENV NODE_ENV=production
WORKDIR /urs/src/app

COPY package.json yarn.lock ./
RUN yarn install --production && yarn cache clean;

COPY . ./
COPY --from=gcr.io/berglas/berglas:latest /bin/berglas /bin/berglas

ENTRYPOINT exec /bin/berglas exec -- yarn start