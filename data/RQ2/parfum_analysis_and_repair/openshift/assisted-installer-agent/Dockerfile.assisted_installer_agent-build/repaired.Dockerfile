FROM registry.ci.openshift.org/openshift/release:golang-1.17
ENV GO111MODULE=on
ENV GOFLAGS=""

RUN yum install -y docker docker-compose && \
    yum clean all && rm -rf /var/cache/yum
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.24.0
RUN go get -u golang.org/x/tools/cmd/goimports@v0.1.0 \
              github.com/onsi/ginkgo/ginkgo@v1.16.1  \
              github.com/golang/mock/mockgen@v1.4.3  \
              github.com/vektra/mockery/.../@v1.1.2 \
              gotest.tools/gotestsum@v1.6.3 \
              github.com/axw/gocov/gocov \
              github.com/AlekSi/gocov-xml@v0.0.0-20190121064608-3a14fb1c4737
