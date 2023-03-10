# This dockerfile is specific to building Multus for OpenShift
FROM openshift/origin-release:golang-1.16 as builder

ADD . /usr/src/multus-cni

WORKDIR /usr/src/multus-cni
ENV GO111MODULE=off
RUN ./hack/build-go.sh

FROM openshift/origin-base
LABEL org.opencontainers.image.source https://github.com/k8snetworkplumbingwg/multus-cni
RUN mkdir -p /usr/src/multus-cni/images && mkdir -p /usr/src/multus-cni/bin && rm -rf /usr/src/multus-cni/images
COPY --from=builder /usr/src/multus-cni/bin/multus /usr/src/multus-cni/bin
ADD ./images/entrypoint.sh /

LABEL io.k8s.display-name="Multus CNI" \
      io.k8s.description="This is a component of OpenShift Container Platform and provides a meta CNI plugin." \
      io.openshift.tags="openshift" \
      maintainer="Doug Smith <dosmith@redhat.com>"

ENTRYPOINT ["/entrypoint.sh"]
