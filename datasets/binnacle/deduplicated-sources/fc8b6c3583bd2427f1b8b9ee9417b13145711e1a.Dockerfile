FROM registry.svc.ci.openshift.org/ocp/builder:golang-1.12 AS builder
WORKDIR /go/src/github.com/openshift/machine-config-operator
COPY . .
RUN WHAT=machine-config-operator ./hack/build-go.sh; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/machine-config-operator/_output/linux/$(go env GOARCH)/machine-config-operator /tmp/build/machine-config-operator
RUN WHAT=machine-config-daemon ./hack/build-go.sh; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/machine-config-operator/_output/linux/$(go env GOARCH)/machine-config-daemon /tmp/build/machine-config-daemon
RUN WHAT=machine-config-controller ./hack/build-go.sh; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/machine-config-operator/_output/linux/$(go env GOARCH)/machine-config-controller /tmp/build/machine-config-controller
RUN WHAT=machine-config-server ./hack/build-go.sh; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/machine-config-operator/_output/linux/$(go env GOARCH)/machine-config-server /tmp/build/machine-config-server
RUN WHAT=setup-etcd-environment ./hack/build-go.sh; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/machine-config-operator/_output/linux/$(go env GOARCH)/setup-etcd-environment /tmp/build/setup-etcd-environment

FROM registry.svc.ci.openshift.org/ocp/4.0:base
COPY --from=builder /tmp/build/machine-config-operator /usr/bin/
COPY install /manifests
COPY --from=builder /tmp/build/machine-config-daemon /usr/bin/
RUN yum install -y util-linux && yum clean all && rm -rf /var/cache/yum/*
COPY --from=builder /tmp/build/machine-config-controller /usr/bin/
COPY templates /etc/mcc/templates
COPY --from=builder /tmp/build/machine-config-server /usr/bin/
COPY --from=builder /tmp/build/setup-etcd-environment /usr/bin/
ENTRYPOINT ["/usr/bin/machine-config-operator"]
LABEL io.openshift.release.operator true
