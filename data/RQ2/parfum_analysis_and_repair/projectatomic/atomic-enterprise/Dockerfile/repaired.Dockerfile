#
# This is the unofficial OpenShift Origin image for the DockerHub. It has as its
# entrypoint the OpenShift all-in-one binary.
#
# See images/origin for the official release version of this image
#
# The standard name for this image is openshift/origin
#
FROM openshift/origin-base

RUN yum install -y golang && yum clean all && rm -rf /var/cache/yum

WORKDIR /go/src/github.com/projectatomic/atomic-enterprise
ADD .   /go/src/github.com/projectatomic/atomic-enterprise
ENV GOPATH /go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN go get github.com/projectatomic/atomic-enterprise && \
    hack/build-go.sh && \
    cp _output/local/go/bin/* /usr/bin/ && \
    mkdir -p /var/lib/openshift

EXPOSE 8080 8443
WORKDIR /var/lib/openshift
ENTRYPOINT ["/usr/bin/openshift"]
