# Dcokerfile for go-gin-wrapper
FROM golang:1.15.6-alpine3.12

RUN apk add --no-cache git mysql-client

#ARG redisHostName=default-redis-server
#ARG mysqlHostName=default-mysql-server
RUN mkdir -p /go/src/github.com/hiromaily/go-gin-wrapper/tmp/ /var/log/goweb/

#ENV REDIS_URL=redis://h:password@${redisHostName}:6379
#ENV CLEARDB_DATABASE_URL=mysql://hiromaily:12345678@mysql-server/hiromaily?reconnect=true