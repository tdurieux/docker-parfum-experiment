FROM golang:1.14 AS builder

WORKDIR $GOPATH/src/github.com/litmuschaos/charthub.litmuschaos.io/app/server

ADD app/server $GOPATH/src/github.com/litmuschaos/charthub.litmuschaos.io/app/server

RUN CGO_ENABLED=0 go build -o /charthub-server -v


FROM alpine:latest

RUN apk update && apk add --no-cache curl bash
RUN apk add --no-cache libc6-compat

COPY --from=builder /charthub-server /

CMD ["/charthub-server"]

EXPOSE 8080