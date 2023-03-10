FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.12
COPY . /go/src/github.com/openshift/csi-driver-manila-operator
RUN cd /go/src/github.com/openshift/csi-driver-manila-operator && \
    go build -mod vendor -o csi-driver-manila-operator cmd/csi-driver-manila-operator/main.go

FROM registry.ci.openshift.org/ocp/4.12:base

ENV OPERATOR=/usr/local/bin/csi-driver-manila-operator \
    USER_UID=1001 \
    USER_NAME=csi-driver-manila-operator

COPY --from=0 /go/src/github.com/openshift/csi-driver-manila-operator/csi-driver-manila-operator ${OPERATOR}

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}