FROM golang
COPY ./server /go/src/github.com/envoyproxy/envoy/example/load-reporting-service/server
COPY *.go /go/src/github.com/envoyproxy/envoy/example/load-reporting-service/
COPY go.sum /go/src/github.com/envoyproxy/envoy/example/load-reporting-service
COPY go.mod /go/src/github.com/envoyproxy/envoy/example/load-reporting-service

WORKDIR /go/src/github.com/envoyproxy/envoy/example/load-reporting-service
RUN go mod download
RUN go install /go/src/github.com/envoyproxy/envoy/example/load-reporting-service

CMD ["go","run","main.go"]