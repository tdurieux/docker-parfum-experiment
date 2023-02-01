# Stage 1 - compile the binary
FROM golang:1.10 as builder
# Get initial dependencies, to save on repeated build time.
WORKDIR /go/src
RUN go get -d -v \
  cloud.google.com/go/bigquery \
	k8s.io/client-go/... \
	github.com/dparrish/go-autoconfig
ADD *.go /go/src
# Compile the binary using static linking.
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/billing ./billing.go
RUN strip /go/billing

# Stage 2 - build a minimal binary iamge.