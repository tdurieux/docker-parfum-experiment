FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.17-openshift-4.11 AS builder
WORKDIR /go/src/github.com/openshift/oc-mirror
COPY . .
RUN make build

FROM registry.ci.openshift.org/ocp/4.11:base
WORKDIR /go/src/github.com/openshift/oc-mirror
COPY . .
COPY --from=builder /go/src/github.com/openshift/oc-mirror/bin/oc-mirror bin/oc-mirror

RUN cd test/integration \
 && scripts/ci-prereqs.sh