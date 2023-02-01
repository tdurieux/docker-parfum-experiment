FROM node:13.7-alpine

RUN apk update \
    && apk upgrade \
    && apk add --no-cache curl g++ python3-dev libffi-dev openssl-dev git && \
    apk add --no-cache --update python && \
    apk add --no-cache --update redis && \
    pip3 install --no-cache-dir --upgrade pip setuptools

WORKDIR /etc/athena
COPY package.json .
RUN npm install && npm install -g pm2 && npm cache clean --force;
EXPOSE 5000

COPY . .

CMD [ "node", "athena.js", "run"]