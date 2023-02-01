FROM dockersecplayground/alpine:latest

RUN apk --update --no-cache add gcc vim nano make musl-dev
