###############################################################################
# STEP 1: Build executable binary

FROM golang:alpine as builder

# Install SSL ca certificates
RUN apk update && apk add --no-cache git && apk add --no-cache ca-certificates

# Create appuser
RUN adduser -D -g '' appuser

# Copy go modules from repository
COPY pkg/amqpclient /go/pkg/amqpclient
COPY pkg/interaction /go/pkg/interaction
COPY pkg/logging /go/pkg/logging

# Copy everything required to download (& cache) dependencies
COPY cmd/grpc-endpoint-egress/go.mod /go/cmd/grpc-endpoint-egress/go.mod
COPY cmd/grpc-endpoint-egress/go.sum /go/cmd/grpc-endpoint-egress/go.sum

WORKDIR /go/cmd/grpc-endpoint-egress/

# Download dependencies
RUN go mod download

# Copy sourcecode
COPY cmd/grpc-endpoint-egress /go/cmd/grpc-endpoint-egress

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/main

###############################################################################
# STEP 2: Build the image

FROM scratch as prod

# Copy SSL certificates & user from STEP 1
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd

# Copy the self-containing binary from STEP 1
COPY --from=builder /go/bin/main /go/bin/main

USER appuser

ENTRYPOINT ["/go/bin/main"]
