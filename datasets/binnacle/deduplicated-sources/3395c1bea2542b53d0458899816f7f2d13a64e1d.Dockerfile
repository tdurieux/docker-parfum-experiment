FROM registry.svc.ci.openshift.org/ocp/builder:golang-1.10 AS builder
RUN yum install -y libvirt-devel

WORKDIR /go/src/github.com/openshift/cluster-api-provider-libvirt
COPY . .
RUN go build -o machine-controller-manager ./cmd/manager
RUN go build -o manager ./vendor/github.com/openshift/cluster-api/cmd/manager

FROM registry.svc.ci.openshift.org/ocp/4.0:base
RUN INSTALL_PKGS=" \
      libvirt-libs openssh-clients genisoimage \
      " && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all
COPY --from=builder /go/src/github.com/openshift/cluster-api-provider-libvirt/manager /
COPY --from=builder /go/src/github.com/openshift/cluster-api-provider-libvirt/machine-controller-manager /
