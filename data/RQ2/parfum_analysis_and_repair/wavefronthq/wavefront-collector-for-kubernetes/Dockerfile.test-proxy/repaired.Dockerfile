FROM harbor-repo.vmware.com/dockerhub-proxy-cache/bitnami/golang:1.18 as builder

# Base Setup
ARG BINARY_NAME
ARG LDFLAGS
WORKDIR /workspace
# Copy the Go Modules manifests

# Copy `go.mod` for definitions and `go.sum` to invalidate the next layer
# in case of a change in the dependencies
COPY go.mod go.sum ./

# Copy src
COPY . .

# Then build
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -ldflags "${LDFLAGS}" -a -o ${BINARY_NAME} ./cmd/test-proxy/...

FROM scratch
WORKDIR /
COPY --from=builder /workspace/test-proxy .

#   nobody:nobody
USER 65534:65534
ENTRYPOINT ["/test-proxy"]