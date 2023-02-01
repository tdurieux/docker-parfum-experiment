FROM alpine:3.8
RUN apk add --no-cache nodejs python make g++ npm
WORKDIR /app
COPY ./example-app /app
RUN npm install && npm cache clean --force;
ENTRYPOINT ["node", "index.js"]