# This dockerfile is specific to building Multus for OpenShift
FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.16-openshift-4.8 AS rhel8
ADD . /usr/src/multus-cni
WORKDIR /usr/src/multus-cni
ENV CGO_ENABLED=1
ENV GO111MODULE=off
ENV VERSION=rhel8 COMMIT=unset
RUN ./hack/build-go.sh && \
       cd /usr/src/multus-cni/bin
WORKDIR /

FROM registry.ci.openshift.org/ocp/builder:rhel-7-golang-1.15-openshift-4.8 AS rhel7
ADD . /usr/src/multus-cni
WORKDIR /usr/src/multus-cni
ENV CGO_ENABLED=1
ENV GO111MODULE=off
RUN ./hack/build-go.sh && \
       cd /usr/src/multus-cni/bin

WORKDIR /usr/src/multus-cni
ENV GO111MODULE=off
<<<<<<<< HEAD:deployments/Dockerfile.openshift
RUN ./hack/build-go.sh

FROM openshift/origin-base
LABEL org.opencontainers.image.source https://github.com/k8snetworkplumbingwg/multus-cni
RUN mkdir -p /usr/src/multus-cni/images && mkdir -p /usr/src/multus-cni/bin && rm -rf /usr/src/multus-cni/images
COPY --from=builder /usr/src/multus-cni/bin/multus /usr/src/multus-cni/bin
========
RUN ./hack/build-go.sh && \
       cd /usr/src/multus-cni/bin
RUN ls -lathr /usr/src/multus-cni/bin/multus
WORKDIR /

FROM registry.ci.openshift.org/ocp/4.8:base
RUN mkdir -p /usr/src/multus-cni/images && \
       mkdir -p /usr/src/multus-cni/bin && \
       mkdir -p /usr/src/multus-cni/rhel7/bin && \
       mkdir -p /usr/src/multus-cni/rhel8/bin && rm -rf /usr/src/multus-cni/images
COPY --from=rhel7 /usr/src/multus-cni/bin/multus /usr/src/multus-cni/rhel7/bin
COPY --from=rhel8 /usr/src/multus-cni/bin/multus /usr/src/multus-cni/bin
COPY --from=rhel8 /usr/src/multus-cni/bin/multus /usr/src/multus-cni/rhel8/bin
>>>>>>>> master:Dockerfile.openshift
ADD ./images/entrypoint.sh /

LABEL io.k8s.display-name="Multus CNI" \
      io.k8s.description="This is a component of OpenShift Container Platform and provides a meta CNI plugin." \
      io.openshift.tags="openshift" \
      maintainer="Doug Smith <dosmith@redhat.com>"

ENTRYPOINT ["/entrypoint.sh"]
