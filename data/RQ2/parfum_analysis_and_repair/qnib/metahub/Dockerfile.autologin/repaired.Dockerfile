FROM golang:1.12-alpine AS go
RUN apk add --no-cache git
WORKDIR /go/metahub
COPY ./go.mod .
COPY ./go.sum .
RUN go mod download
COPY ./cmd ./cmd
COPY ./pkg ./pkg
WORKDIR /go/metahub/cmd/autologin
ENV CGO_ENABLED=0 GOOS=linux
RUN go build -a -ldflags '-extldflags "-static"' .


# Go binary serves the ui web content
FROM alpine:3.12.3
RUN apk add --no-cache --update docker util-linux
COPY --from=go /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=go /go/metahub/cmd/autologin/autologin /usr/bin/autologin
ENTRYPOINT ["/usr/bin/autologin"]
CMD ["-docker-login"]