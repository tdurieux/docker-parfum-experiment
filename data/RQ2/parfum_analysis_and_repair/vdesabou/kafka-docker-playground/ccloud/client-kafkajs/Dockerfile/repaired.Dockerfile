FROM node:lts-alpine
RUN apk update && apk upgrade && apk add --no-cache iptables
# Create app directory
WORKDIR /usr/src/app

RUN npm install kafkajs console-stamp && npm cache clean --force;

# Copy files
COPY producer.js /usr/src/app
COPY consumer.js /usr/src/app

# uncomment if run with k8s
#CMD node /usr/src/app/producer.js