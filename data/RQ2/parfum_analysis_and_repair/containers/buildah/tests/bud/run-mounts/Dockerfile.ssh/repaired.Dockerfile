FROM alpine

RUN apk add --no-cache openssh-client

RUN --mount=type=ssh,id=default ssh-add -l -E md5
