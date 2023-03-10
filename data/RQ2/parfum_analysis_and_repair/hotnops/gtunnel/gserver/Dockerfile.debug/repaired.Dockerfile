FROM gtunnel-server:latest
RUN go get -u github.com/go-delve/delve/cmd/dlv

CMD ["dlv", "--headless", "--listen=0.0.0.0:2345", "--api-version=2", "debug", "gserver/gServer.go"]