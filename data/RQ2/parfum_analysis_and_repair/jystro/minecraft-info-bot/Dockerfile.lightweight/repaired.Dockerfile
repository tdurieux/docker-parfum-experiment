FROM alpine:3.14

RUN apk add --no-cache npm

COPY package*.json /app/

WORKDIR /app

RUN mkdir ./data

RUN npm ci

COPY . .

ENV DISCORD_TOKEN=

CMD ["node", "."]