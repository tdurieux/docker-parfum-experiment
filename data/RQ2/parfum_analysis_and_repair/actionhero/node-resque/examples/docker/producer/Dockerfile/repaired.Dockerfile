FROM alpine:latest

WORKDIR /node-resque-demo

RUN apk add --no-cache --update nodejs nodejs-npm

COPY package.json .
COPY tsconfig.json .
COPY src src

# npm install will also run npm prepare, compiling the typescript
RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm prune

CMD ["node", "dist/producer.js"]
