FROM registry.svc.ci.openshift.org/openshift/release:golang-1.13 AS builder
WORKDIR /go/src/github.com/openshift/openshift-tests
COPY . .
RUN make build && \
    mkdir -p /tmp/build && \
    cp /go/src/github.com/openshift/openshift-tests/bin/extended-platform-tests /tmp/build/extended-platform-tests

FROM registry.svc.ci.openshift.org/ocp/4.6:cli
COPY --from=builder /tmp/build/extended-platform-tests /usr/bin/
LABEL io.k8s.display-name="OpenShift Extended Platform Tests" \
      io.k8s.description="OpenShift is a platform for developing, building, and deploying containerized applications." \
      io.openshift.tags="openshift,tests,extended-platform"