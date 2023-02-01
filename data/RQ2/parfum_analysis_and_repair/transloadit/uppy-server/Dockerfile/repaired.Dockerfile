FROM alpine:3.6

RUN apk add --no-cache --update nodejs \
												nodejs-npm

COPY package.json /app/package.json

WORKDIR /app

RUN apk --update --no-cache add --virtual native-dep \
  make gcc g++ python libgcc libstdc++ && gcc g++ python libgcc libstdc++ && \
  npm  install && \
  apk del native-dep && npm cache clean --force;
RUN apk add --no-cache bash
COPY . /app
RUN npm run build
CMD ["node","/app/lib/standalone/start-server.js"]
# This can be overwritten later
EXPOSE 3020

