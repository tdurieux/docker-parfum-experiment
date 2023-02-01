# This Dockerfile is used by CI to publish the oc-mirror image.
FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.12 AS builder
WORKDIR /go/src/github.com/openshift/oc-mirror
COPY . .
RUN make build

FROM registry.ci.openshift.org/ocp/4.12:base
COPY --from=builder /go/src/github.com/openshift/oc-mirror/bin/oc-mirror /usr/bin/

LABEL io.k8s.display-name="oc-mirror" \
      io.k8s.description="OpenShift is a platform for developing, building, and deploying containerized applications." \
      io.openshift.tags="openshift,cli,mirror" \
      # We're not really an operator, we're just getting some data into the release image.