# This dockerfile is used for building for OpenShift
FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.11 AS rhel8
ADD . /go/src/github.com/k8snetworkplumbingwg/whereabouts
WORKDIR /go/src/github.com/k8snetworkplumbingwg/whereabouts
ENV CGO_ENABLED=1
ENV GO111MODULE=on
ENV VERSION=rhel8 COMMIT=unset
RUN go build -mod vendor -o bin/whereabouts cmd/whereabouts.go
RUN go build -mod vendor -o bin/ip-reconciler cmd/reconciler/*.go
WORKDIR /

FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.11 AS rhel7
ADD . /go/src/github.com/k8snetworkplumbingwg/whereabouts
WORKDIR /go/src/github.com/k8snetworkplumbingwg/whereabouts
ENV CGO_ENABLED=1
ENV GO111MODULE=on
RUN go build -mod vendor -o bin/whereabouts cmd/whereabouts.go
WORKDIR /

FROM registry.ci.openshift.org/ocp/builder:rhel-8-base-openshift-4.11
RUN mkdir -p /usr/src/whereabouts/images && \
       mkdir -p /usr/src/whereabouts/bin && \
       mkdir -p /usr/src/whereabouts/rhel7/bin && \
       mkdir -p /usr/src/whereabouts/rhel8/bin && rm -rf /usr/src/whereabouts/images
COPY --from=rhel7 /go/src/github.com/k8snetworkplumbingwg/whereabouts/bin/whereabouts /usr/src/whereabouts/rhel7/bin
COPY --from=rhel8 /go/src/github.com/k8snetworkplumbingwg/whereabouts/bin/whereabouts /usr/src/whereabouts/bin
COPY --from=rhel8 /go/src/github.com/k8snetworkplumbingwg/whereabouts/bin/whereabouts /usr/src/whereabouts/rhel8/bin
COPY --from=rhel8 /go/src/github.com/k8snetworkplumbingwg/whereabouts/bin/ip-reconciler /ip-reconciler

LABEL io.k8s.display-name="Whereabouts CNI" \
      io.k8s.description="This is a component of OpenShift Container Platform and provides a cluster-wide IPAM CNI plugin." \
      io.openshift.tags="openshift" \
      maintainer="CTO Networking <nfvpe-container@redhat.com>"
