FROM node:12.18-alpine
ENV NODE_ENV test
WORKDIR /usr/src/app
COPY [ "package.json", "." ]
RUN apk add --no-cache ca-certificates
RUN npm install && npm cache clean --force;
COPY . .
