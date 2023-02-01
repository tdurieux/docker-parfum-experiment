FROM node:lts-alpine

RUN apk add --no-cache curl

WORKDIR /web

COPY package*.json ./

RUN npm ci --only=production --ignore-scripts

COPY . .

RUN npm run tailwind

CMD [ "npm", "start"]
