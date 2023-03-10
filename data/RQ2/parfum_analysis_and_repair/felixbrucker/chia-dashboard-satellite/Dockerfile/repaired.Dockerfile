FROM node:16-alpine

RUN apk update && apk add --no-cache bash
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .

ENTRYPOINT ["yarn"]
CMD ["start"]
