FROM alpine

LABEL maintainer = "ali@gmail.com"

RUN apk add --no-cache --update node.js nodejs -npm

COPY . /src

WORKDIR /src

RUN npm install && npm cache clean --force;

ENV createdby="Ali"

EXPOSE 8080

ENTRYPOINT ["node", "./app.js"]
