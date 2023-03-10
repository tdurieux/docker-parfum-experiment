FROM golang:alpine as builder
RUN apk add --no-cache git
WORKDIR /go/src/github.com/discourse/discourse-auth-proxy
COPY internal ./internal/
COPY *.go ./
RUN go get && go build

FROM alpine:latest
COPY localhost.cert /bin/
COPY localhost.key /bin/
COPY --from=builder /go/bin/discourse-auth-proxy /bin/
COPY start.sh /bin/start.sh
CMD ["/bin/start.sh"]
