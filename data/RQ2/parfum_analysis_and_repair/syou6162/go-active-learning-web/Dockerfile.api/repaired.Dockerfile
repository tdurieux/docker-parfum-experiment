FROM golang:1.16-alpine AS builder
RUN apk add --no-cache make git build-base
WORKDIR /go/src/github.com/syou6162/go-active-learning-web/
COPY . .
RUN make deps build

FROM alpine:3.13.2
RUN apk add --no-cache ca-certificates
ENV APP_PATH="/app"
WORKDIR ${APP_PATH}
COPY --from=builder /go/src/github.com/syou6162/go-active-learning-web/go-active-learning-web ${APP_PATH}/go-active-learning.bin