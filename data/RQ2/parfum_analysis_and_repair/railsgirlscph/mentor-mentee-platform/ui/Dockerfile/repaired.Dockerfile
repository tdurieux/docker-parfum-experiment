FROM node:current-alpine

RUN apk add --no-cache --update tini
WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install \
    && npm cache clean --force

COPY . ./

CMD ["npm", "start"]


