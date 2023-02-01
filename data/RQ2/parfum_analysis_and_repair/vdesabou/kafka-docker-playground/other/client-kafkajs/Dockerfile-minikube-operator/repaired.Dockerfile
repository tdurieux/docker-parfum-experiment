FROM node:lts-alpine
RUN apk update && apk upgrade && apk add --no-cache iptables
#RUN npm install kafkajs console-stamp
RUN npm install kafkajs@1.15.0 console-stamp && npm cache clean --force;
# Create app directory
WORKDIR /usr/src/app

# Copy files
COPY producer-minikube-operator.js /usr/src/app/producer.js
COPY consumer.js /usr/src/app

CMD node /usr/src/app/producer.js