FROM alpine:latest

RUN apk update && apk add --no-cache bash

COPY ./dist/cron_linux_amd64_v1/cron assistant-cron
CMD ["./assistant-cron"]
