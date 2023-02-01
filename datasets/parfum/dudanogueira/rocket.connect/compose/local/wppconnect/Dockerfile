FROM node:14.17-alpine3.13 as builder

ENV PORT=21465

RUN apk add wget && \
    apk add --no-cache git

WORKDIR /home/node
RUN git clone https://github.com/wppconnect-team/wppconnect-server.git /home/node/app

WORKDIR /home/node/app


RUN yarn install

FROM node:14.17-alpine3.13
WORKDIR /home/node/app
RUN apk add chromium
COPY --from=builder /home/node/app/ .

COPY ./config.json /home/node/app/src

EXPOSE 21465
