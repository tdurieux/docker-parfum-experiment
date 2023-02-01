FROM alpine

RUN apk update; apk upgrade; apk add --no-cache freeradius; apk add --no-cache freeradius-checkrad freeradius-radclient
