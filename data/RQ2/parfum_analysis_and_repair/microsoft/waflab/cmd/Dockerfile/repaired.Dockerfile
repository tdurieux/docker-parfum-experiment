FROM golang:1.16

WORKDIR /go/src/app
COPY . .

# INSTALL DEPS
RUN go get -d -v ./...

# INSTALL WAFLAB-CLI
RUN cd cmd/
RUN go build -o $GOPATH/bin/waflab cmd/main.go

CMD ["waflab"]