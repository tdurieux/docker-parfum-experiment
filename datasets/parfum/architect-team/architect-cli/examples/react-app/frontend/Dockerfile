FROM node:14-alpine

RUN apk --no-cache add curl

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

CMD [ "npm", "run", "start" ]
