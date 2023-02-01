FROM node:17.0.1-alpine

ENV NO_UPDATE_NOTIFIER true

RUN apk --no-cache add git

WORKDIR /usr/app

COPY package.json package-lock.json ./

RUN npm install --no-optional

COPY . /usr/app

RUN npm run build

EXPOSE 8080

ENTRYPOINT ["npm", "start"]
