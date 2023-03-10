FROM golang:1.18 as builder
ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go
ENV K8S_VERSION=1.19.2

# Install required go binaries
RUN go install github.com/ory/go-acc@v0.2.8

WORKDIR /go/src/github.com/liqotech/liqo
COPY go.mod ./go.mod
COPY go.sum ./go.sum
RUN  go mod download

# Install kubebuilder
RUN curl --fail -sSLo envtest-bins.tar.gz "https://storage.googleapis.com/kubebuilder-tools/kubebuilder-tools-${K8S_VERSION}-$(go env GOOS)-$(go env GOARCH).tar.gz"
RUN mkdir /usr/local/kubebuilder/
RUN tar -C /usr/local/kubebuilder/ --strip-components=1 -zvxf envtest-bins.tar.gz && rm envtest-bins.tar.gz

# Install iptables
RUN apt-get update && apt-get install --no-install-recommends iptables iproute2 -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT go-acc ./... --ignore liqo/test/e2e -- -vet=off
