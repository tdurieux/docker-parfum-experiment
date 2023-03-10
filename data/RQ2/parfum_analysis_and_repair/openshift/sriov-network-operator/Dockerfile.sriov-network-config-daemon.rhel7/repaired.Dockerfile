FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.17-openshift-4.11 AS builder
WORKDIR /go/src/github.com/k8snetworkplumbingwg/sriov-network-operator
COPY . .
RUN make _build-sriov-network-config-daemon BIN_PATH=build/_output/cmd
RUN make plugins BIN_PATH=build/_output/pkg

FROM registry.ci.openshift.org/ocp/4.11:base
RUN yum -y update && ARCH_DEP_PKGS=$(if [ "$(uname -m)" != "s390x" ]; then echo -n mstflint ; fi) && yum -y install hwdata $ARCH_DEP_PKGS && yum clean all && rm -rf /var/cache/yum
LABEL io.k8s.display-name="OpenShift sriov-network-config-daemon" \
      io.k8s.description="This is a daemon that manage and config sriov network devices in Openshift cluster" \
      io.openshift.tags="openshift,networking,sr-iov" \
      maintainer="Multus team <multus-dev@redhat.com>"
COPY --from=builder /go/src/github.com/k8snetworkplumbingwg/sriov-network-operator/build/_output/cmd/sriov-network-config-daemon /usr/bin/
COPY --from=builder /go/src/github.com/k8snetworkplumbingwg/sriov-network-operator/build/_output/pkg/plugins /plugins
COPY bindata /bindata
ENV PLUGINSPATH=/plugins
ENV CLUSTER_TYPE=openshift
CMD ["/usr/bin/sriov-network-config-daemon"]
