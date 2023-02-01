FROM golang:1.17-alpine
RUN apk add --no-cache upx
RUN apk add --no-cache git
