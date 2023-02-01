FROM klakegg/hugo:ext-alpine

RUN apk add --no-cache git npm

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;
