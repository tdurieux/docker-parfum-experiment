FROM alpine:latest

RUN apk update && apk add --no-cache bash

COPY ./dist/user_linux_amd64_v1/user assistant-user
CMD ["./assistant-user"]
