FROM registry.svc.ci.openshift.org/ocp/builder:golang-1.12 AS builder
WORKDIR /go/src/github.com/openshift/origin
COPY . .
RUN make build WHAT=vendor/k8s.io/kubernetes/cmd/hyperkube; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/origin/_output/local/bin/linux/$(go env GOARCH)/hyperkube /tmp/build/hyperkube

FROM registry.svc.ci.openshift.org/ocp/4.2:base
COPY --from=builder /tmp/build/hyperkube /usr/bin/
LABEL io.k8s.display-name="OpenShift Kubernetes Server Commands" \
      io.k8s.description="OpenShift is a platform for developing, building, and deploying containerized applications." \
      io.openshift.tags="openshift,hyperkube" \
      io.openshift.build.versions="kubernetes=1.14.0"
