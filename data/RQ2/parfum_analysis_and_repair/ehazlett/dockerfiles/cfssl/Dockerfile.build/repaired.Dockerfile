FROM alpine
RUN apk --update --no-cache add go git
ENV GOPATH /go
RUN go get -u github.com/cloudflare/cfssl/cmd/...
