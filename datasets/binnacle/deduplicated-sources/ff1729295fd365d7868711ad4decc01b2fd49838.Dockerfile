FROM redis:3.0.7-alpine

RUN  apk add --update iproute2
RUN apk add --no-cache \
        curl \
        bash


EXPOSE 26379
