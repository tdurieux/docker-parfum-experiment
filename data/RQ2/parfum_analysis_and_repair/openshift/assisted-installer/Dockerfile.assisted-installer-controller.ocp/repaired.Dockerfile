FROM registry.ci.openshift.org/ocp/4.11:cli AS cli

FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.11 AS builder

WORKDIR /go/src/github.com/openshift/assisted-installer
ENV GOFLAGS="-mod=vendor"

COPY . .
RUN make controller

FROM registry.ci.openshift.org/ocp/4.11:base

LABEL io.openshift.release.operator=true

COPY --from=builder /go/src/github.com/openshift/assisted-installer/build/assisted-installer-controller /usr/bin/assisted-installer-controller
COPY --from=cli /usr/bin/oc /usr/bin/oc

ENTRYPOINT ["/usr/bin/assisted-installer-controller"]