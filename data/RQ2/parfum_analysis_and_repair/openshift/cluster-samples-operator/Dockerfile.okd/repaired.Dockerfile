FROM registry.ci.openshift.org/openshift/release:golang-1.17 AS builder
WORKDIR /go/src/github.com/openshift/cluster-samples-operator
COPY . .
RUN make build

FROM registry.ci.openshift.org/origin/4.10:base
COPY --from=builder /go/src/github.com/openshift/cluster-samples-operator/cluster-samples-operator /usr/bin/
RUN ln -f /usr/bin/cluster-samples-operator /usr/bin/cluster-samples-operator-watch
COPY manifests/image-references manifests/0* /manifests/
COPY vendor/github.com/openshift/api/samples/v1/0000_10_samplesconfig.crd.yaml /manifests/
COPY assets/operator/okd-x86_64 /opt/openshift/operator/x86_64
RUN useradd cluster-samples-operator
USER cluster-samples-operator
ENTRYPOINT []
CMD ["/usr/bin/cluster-samples-operator"]
LABEL io.openshift.release.operator true