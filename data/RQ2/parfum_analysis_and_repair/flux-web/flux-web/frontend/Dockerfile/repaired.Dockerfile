FROM node:alpine

WORKDIR /app

RUN apk add --no-cache python alpine-sdk

COPY package.json ./
COPY yarn.lock ./

RUN yarn

COPY . .

RUN npm run build

CMD npm start