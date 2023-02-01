FROM registry.svc.ci.openshift.org/ocp/builder:golang-1.12 AS builder
WORKDIR /go/src/github.com/openshift/origin
COPY . .
RUN make build WHAT=cmd/oc; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/origin/_output/local/bin/linux/$(go env GOARCH)/oc /tmp/build/oc

FROM registry.svc.ci.openshift.org/ocp/4.2:base
COPY --from=builder /tmp/build/oc /usr/bin/
RUN for i in kubectl openshift-deploy openshift-docker-build openshift-sti-build openshift-git-clone openshift-manage-dockerfile openshift-extract-image-content openshift-recycle; do ln -s /usr/bin/oc /usr/bin/$i; done
LABEL io.k8s.display-name="OpenShift Client" \
      io.k8s.description="OpenShift is a platform for developing, building, and deploying containerized applications." \
      io.openshift.tags="openshift,cli"
