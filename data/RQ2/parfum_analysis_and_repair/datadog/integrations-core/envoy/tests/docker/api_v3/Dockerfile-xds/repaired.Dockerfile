FROM gcr.io/istio-testing/go-control-plane-ci:08-20-2019

COPY controlplane.go ./controlplane.go
COPY go.mod ./go.mod

RUN go build -o /go/bin/control-plane

ENTRYPOINT /go/bin/control-plane