FROM registry.svc.ci.openshift.org/ocp/builder:golang-1.13 AS builder

COPY . /usr/src/ib-sriov-cni

WORKDIR /usr/src/ib-sriov-cni
RUN make clean && \
    make build

FROM registry.svc.ci.openshift.org/ocp/4.0:base
COPY --from=builder /usr/src/ib-sriov-cni/build/ib-sriov /usr/bin/
WORKDIR /

LABEL io.k8s.display-name="InfiniBand SR-IOV CNI"

COPY ./images/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]