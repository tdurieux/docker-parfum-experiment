ARG REGISTRY
FROM ${REGISTRY}/ubi8/go-toolset:1.16.12 AS builder
ARG MUOVERSION
ENV DOWNLOAD_URL=https://github.com/openshift/managed-upgrade-operator/archive/${MUOVERSION}.tar.gz
ENV GOOS=linux \
    GOPATH=/go/ \
    GOARCH=amd64 \
    CGO_ENABLED=0
WORKDIR ${GOPATH}/src/github.com/openshift/managed-upgrade-operator
USER root
RUN yum update -yq
RUN curl -f -Lq $DOWNLOAD_URL | tar -xz --strip-components=1
RUN go build -gcflags="all=-trimpath=/go/" -asmflags="all=-trimpath=/go/" -tags mandate_fips -o build/_output/bin/managed-upgrade-operator ./cmd/manager

#### Runtime container
FROM ${REGISTRY}/ubi8/ubi-minimal:latest

ENV USER_UID=1001 \
    USER_NAME=managed-upgrade-operator

RUN microdnf update && microdnf clean all
COPY --from=builder /go/src/github.com/openshift/managed-upgrade-operator/build/_output/bin/* \
                    /go/src/github.com/openshift/managed-upgrade-operator/build/bin/* \
                    /usr/local/bin/
RUN /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]
USER ${USER_UID}
LABEL io.openshift.managed.name="managed-upgrade-operator" \
      io.openshift.managed.description="Operator to manage upgrades for Openshift version 4 clusters"
