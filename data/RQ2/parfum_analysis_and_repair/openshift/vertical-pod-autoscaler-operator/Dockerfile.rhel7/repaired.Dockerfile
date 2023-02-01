FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.11 AS builder
WORKDIR /go/src/github.com/openshift/vertical-pod-autoscaler-operator
COPY . .
ENV NO_DOCKER=1
ENV BUILD_DEST=/go/bin/vertical-pod-autoscaler-operator
RUN unset VERSION && make build

FROM registry.ci.openshift.org/ocp/4.11:base
COPY --from=builder /go/bin/vertical-pod-autoscaler-operator /usr/bin/
COPY --from=builder /go/src/github.com/openshift/vertical-pod-autoscaler-operator/install /manifests
CMD ["/usr/bin/vertical-pod-autoscaler-operator"]
#LABEL io.openshift.release.operator true