FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR  /go/src/github.com/openshift/oauth-proxy
COPY . .
RUN go build .

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/oauth-proxy/oauth-proxy /usr/bin/oauth-proxy
ENTRYPOINT ["/usr/bin/oauth-proxy"]
LABEL io.k8s.display-name="OpenShift OAuth Proxy" \
      io.k8s.description="OpenShift OAuth Proxy component of OpenShift" \
      maintainer="OpenShift Auth Team <aos-auth-team@redhat.com>" \
      name="openshift/oauth-proxy" \
      version="v4.0.0" \
      License="GPLv2+" \
      architecture="x86_64" \
      vendor="Red Hat" \
      io.openshift.tags="openshift" \
      com.redhat.component="golang-github-openshift-oauth-proxy-docker" \
      io.openshift.release.operator=true
