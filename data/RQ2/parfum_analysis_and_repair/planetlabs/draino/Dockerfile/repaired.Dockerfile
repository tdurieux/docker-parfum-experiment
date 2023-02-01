FROM golang:1.13.15-alpine3.11 AS build

RUN apk update && apk add --no-cache git && apk add --no-cache curl

WORKDIR /go/src/github.com/planetlabs/draino
COPY . .

RUN go build -o /draino ./cmd/draino

FROM alpine:3.11

RUN apk update && apk add --no-cache ca-certificates
RUN addgroup -S user && adduser -S user -G user
USER user
COPY --from=build /draino /draino
