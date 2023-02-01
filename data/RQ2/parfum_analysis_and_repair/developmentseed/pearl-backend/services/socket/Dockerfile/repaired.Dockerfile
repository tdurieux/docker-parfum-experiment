FROM alpine:3.14

EXPOSE 1999

ENV HOME=/home/lulc
WORKDIR $HOME
COPY ./ $HOME/socket
WORKDIR $HOME/socket

RUN apk add --no-cache nodejs npm
RUN npm install && npm cache clean --force;

CMD npm run dev
