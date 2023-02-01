FROM lwolf/kubebuilder-test-base:0.1

# Copy in the go src
WORKDIR /go/src/github.com/lwolf/kubereplay
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY helpers/ helpers/
COPY vendor/ vendor/

# Build and test the API code
RUN go test ./pkg/... ./cmd/... ./helpers/...