FROM alpine:latest

RUN apk update && apk add --no-cache bash

COPY ./dist/middle_linux_amd64_v1/middle assistant-middle
CMD ["./assistant-middle"]
