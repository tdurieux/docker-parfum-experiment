FROM node:12.20.0-alpine
RUN apk add --no-cache tzdata
COPY . /opt/playout-gateway
WORKDIR /opt/playout-gateway
CMD ["yarn", "start"]