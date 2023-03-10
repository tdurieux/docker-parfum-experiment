FROM openshift/golang-builder:1.15 AS builder

COPY $REMOTE_SOURCE $REMOTE_SOURCE_DIR
RUN mkdir /workspace
WORKDIR /workspace
RUN cp -Rp $REMOTE_SOURCE_DIR/app/* /workspace

RUN go build -o manager


FROM registry.redhat.io/ubi8:8.4

LABEL com.redhat.component="quay-operator-container"
LABEL name="quay/quay-operator-rhel8"
LABEL version="v3.6.0"
LABEL display-name="Red Hat Quay Operator"
LABEL io.k8s.display-name="Red Hat Quay Operator"
LABEL summary="Red Hat Quay Operator"
LABEL description="Red Hat Quay Operator"
LABEL maintainer="support@redhat.com"
LABEL io.openshift.tags="quay"

RUN mkdir /workspace
WORKDIR /workspace
COPY --from=builder /workspace/manager /workspace/manager
COPY --from=builder $REMOTE_SOURCE_DIR/app/kustomize /workspace/kustomize
ENTRYPOINT ["/workspace/manager"]