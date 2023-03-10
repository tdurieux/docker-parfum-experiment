FROM node:alpine

WORKDIR /usr/src/app
COPY src .
COPY package.json .

RUN apk --no-cache add exiftool && \
    npm i && npm cache clean --force;

EXPOSE 80 443
CMD ["node", "index.js"]
