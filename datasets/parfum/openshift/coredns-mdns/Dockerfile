FROM registry.svc.ci.openshift.org/openshift/release:golang-1.11 AS builder
WORKDIR /go/src/github.com/openshift-metal3/coredns-mdns
COPY . .
RUN git clone https://github.com/coredns/coredns /go/src/github.com/coredns/coredns
WORKDIR /go/src/github.com/coredns/coredns
RUN git apply /go/src/github.com/openshift-metal3/coredns-mdns/containerization/mdns.patch && \
    make

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/coredns/coredns/coredns /usr/bin/

ENTRYPOINT ["/usr/bin/coredns"]

LABEL io.k8s.display-name="CoreDNS" \
      io.k8s.description="CoreDNS delivers the DNS and Discovery Service for a Kubernetes cluster." \
      maintainer="Antoni Segura Puimedon <antoni@redhat.com>"
