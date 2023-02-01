# Build the kdc-api-server in a separate container
FROM golang:1.11
WORKDIR /go/src/github.com/mesosphere/kdc-api-server
RUN go get -d -v golang.org/x/net/html gopkg.in/jcmturner/gokrb5.v7/keytab
COPY server/ /go/src/github.com/mesosphere/kdc-api-server
RUN go get github.com/dcos/client-go/dcos
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o api-server .

# Build a KDC container