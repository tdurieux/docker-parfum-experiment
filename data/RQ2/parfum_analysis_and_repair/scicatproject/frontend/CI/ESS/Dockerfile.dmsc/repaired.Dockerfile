FROM node:16-alpine as builder
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow
ENV http_proxy "http://192.168.1.1:8123"
ENV https_proxy "http://192.168.1.1:8123"
ENV no_proxy "localhost, 127.0.0.1"
RUN apk update && apk upgrade && \
  apk add --no-cache bash git openssh

RUN npm config set proxy  $http_proxy
RUN npm config set https-proxy  $http_proxy
WORKDIR /frontend
COPY package*.json  /frontend/
RUN npm ci
COPY . /frontend/
RUN npx ng build

FROM nginx:alpine
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /frontend/dist/ /usr/share/nginx/html
COPY scripts/nginx.conf /etc/nginx/nginx.conf
ENV http_proxy "http://192.168.1.1:8123"
ENV https_proxy "http://192.168.1.1:8123"
ENV no_proxy "localhost, 127.0.0.1"
EXPOSE 80