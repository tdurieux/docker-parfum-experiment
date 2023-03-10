FROM registry.ci.openshift.org/openshift/release:golang-1.18 AS builder

ENV PKG=/go/src/github.com/integr8ly/integreatly-operator/
WORKDIR ${PKG}

# compile test binary
COPY go.mod go.mod
COPY go.sum go.sum
COPY vendor ./vendor
COPY make ./make
COPY apis/ apis/
COPY apis-products/ apis-products/
COPY controllers/ controllers/
COPY pkg ./pkg
COPY test ./test
COPY Makefile ./
COPY manifests/ ./manifests
COPY products ./products
COPY version ./version

RUN make test/compile/functional

FROM registry.access.redhat.com/ubi8/ubi:latest
# Install chrome for tests
COPY test-dependency/*.repo /etc/yum.repos.d/
RUN dnf -y install google-chrome-stable && dnf clean all

COPY --from=builder /go/src/github.com/integr8ly/integreatly-operator/integreatly-operator-test-harness.test integreatly-operator-test-harness.test

ENTRYPOINT [ "/integreatly-operator-test-harness.test", "-test.v", "-ginkgo.v", "-ginkgo.progress", "-ginkgo.noColor" ]