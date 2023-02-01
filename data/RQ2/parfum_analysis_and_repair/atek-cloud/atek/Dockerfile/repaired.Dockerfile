FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends curl python make automake libtool g++ -y && rm -rf /var/lib/apt/lists/*;
RUN curl -fs https://raw.githubusercontent.com/mafintosh/node-install/master/install | sh
RUN node-install 16.8.0

#FROM node:16-alpine
#RUN apk update
#RUN apk add libtool automake gcc
#RUN apk add --no-cache libtool autoconf automake g++ make
WORKDIR /app
COPY . .
RUN npm i && npm cache clean --force;
CMD ["node", "dist/bin.js"]

