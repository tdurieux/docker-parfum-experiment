FROM openshift/origin-release:golang-1.13
COPY . /go/src/github.com/openshift/csi-driver-manila-operator
RUN cd /go/src/github.com/openshift/csi-driver-manila-operator && \
    go build -mod vendor -o csi-driver-manila-operator cmd/manager/main.go

FROM registry.svc.ci.openshift.org/origin/4.2:base

ENV OPERATOR=/usr/local/bin/csi-driver-manila-operator \
    USER_UID=1001 \
    USER_NAME=csi-driver-manila-operator

COPY --from=0 /go/src/github.com/openshift/csi-driver-manila-operator/csi-driver-manila-operator ${OPERATOR}

COPY bundle /bundle

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]

LABEL com.redhat.delivery.appregistry=true

USER ${USER_UID}