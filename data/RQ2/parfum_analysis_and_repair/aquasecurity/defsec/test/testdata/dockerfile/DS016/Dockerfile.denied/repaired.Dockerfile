FROM golang:1.7.3
USER mike
CMD ./app
CMD ./apps
FROM alpine:3.13
CMD ./app