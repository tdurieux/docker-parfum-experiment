FROM node:14-alpine3.10

#docker build --tag labot .
#docker run --restart unless-stopped --name labot --hostname labot -d -p 30937:3002 -p 30901:3001 -p 30922:22 labot:latest

RUN apk update

RUN apk add --no-cache curl
RUN apk add --no-cache npm
RUN apk add --no-cache git
RUN apk add --no-cache --update build-base
RUN apk add --no-cache g++
RUN apk add --no-cache python
RUN apk add --no-cache make
RUN apk add --no-cache mc
RUN apk add --no-cache screen

RUN cd root && git clone https://github.com/swaponline/MultiCurrencyWallet && cd MultiCurrencyWallet && npm i && npm cache clean --force;

EXPOSE 1337 3001 3002 22

CMD ["npm", "run", "marketmaker"]
