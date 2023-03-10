FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.16-openshift-4.9 AS builder

COPY . /usr/src/sriov-cni

WORKDIR /usr/src/sriov-cni
RUN make clean && \
    make build

FROM registry.ci.openshift.org/ocp/4.9:base
COPY --from=builder /usr/src/sriov-cni/build/sriov /usr/bin/
WORKDIR /

LABEL io.k8s.display-name="SR-IOV CNI"

COPY ./images/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]