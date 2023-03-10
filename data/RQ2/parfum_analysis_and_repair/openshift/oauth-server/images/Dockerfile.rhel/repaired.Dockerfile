FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.11 AS builder
WORKDIR /go/src/github.com/openshift/oauth-server
COPY . .
ENV GO_PACKAGE github.com/openshift/oauth-server
RUN make build --warn-undefined-variables

FROM registry.ci.openshift.org/ocp/4.11:base
COPY --from=builder /go/src/github.com/openshift/oauth-server/oauth-server /usr/bin/
ENTRYPOINT ["/usr/bin/oauth-server"]
LABEL io.k8s.display-name="OpenShift OAuth Server" \
      io.k8s.description="This is a component of OpenShift and enables cluster authentication" \
      com.redhat.component="oauth-server" \
      name="openshift/ose-oauth-server" \
      io.openshift.tags="openshift, oauth-server"