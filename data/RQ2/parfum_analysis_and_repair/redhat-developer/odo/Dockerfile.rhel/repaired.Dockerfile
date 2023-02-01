# This Dockerfile builds an image containing the Linux, Mac and Windows version of odo
# layered on top of the ubi7/ubi image.

FROM registry.svc.ci.openshift.org/openshift/release:golang-1.17 AS builder

COPY . /go/src/github.com/redhat-developer/odo
WORKDIR /go/src/github.com/redhat-developer/odo
RUN make cross

FROM registry.access.redhat.com/ubi7/ubi

LABEL com.redhat.component=atomic-openshift-odo-cli-artifacts-container \ 
    name=redhat-developer/odo-cli-artifacts \ 
    io.k8s.display-name=atomic-openshift-odo-cli-artifacts-image \
    maintainer=devtools-deploy@redhat.com \ 
    summary="This image contains the Linux, Mac and Windows version of odo"

# Change version as needed. Note no "-" is allowed