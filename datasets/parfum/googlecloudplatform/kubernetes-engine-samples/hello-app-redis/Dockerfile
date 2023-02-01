FROM golang:1.16-alpine
RUN apk add --no-cache git
ADD . /go/src/hello-app
WORKDIR /go/src/hello-app
RUN go get -d -v ./...
RUN go install hello-app

FROM alpine:latest
COPY --from=0 /go/src/hello-app .
COPY --from=0 /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]