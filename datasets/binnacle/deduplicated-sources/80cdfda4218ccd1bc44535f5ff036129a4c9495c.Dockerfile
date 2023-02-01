FROM golang:latest

WORKDIR /go/src
COPY . github.com/webflow/kubekite
WORKDIR /go/src/github.com/webflow/kubekite/cmd/kubekite

# Build and strip our binary
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -a -installsuffix cgo -o kubekite .
