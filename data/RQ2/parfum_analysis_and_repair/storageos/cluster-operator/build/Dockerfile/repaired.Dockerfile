ARG BUILD_IMAGE=golang:1.15.2
ARG BASE_IMAGE=registry.access.redhat.com/ubi8/ubi-minimal
ARG OPERATOR_IMAGE=storageos/cluster-operator:test

FROM ${BUILD_IMAGE} AS build
# OPERATOR_IMAGE needs to be passed to operator make target for constructing
# the ldflags.
ARG OPERATOR_IMAGE
WORKDIR /go/src/github.com/storageos/cluster-operator/
COPY . /go/src/github.com/storageos/cluster-operator/
# Temporarily clone code-gen because the new version of the vendored tools
# expect it to be in the $GOPATH. Code generation will be removed for dynamic
# client in the future.
RUN git clone https://github.com/kubernetes/code-generator $GOPATH/src/k8s.io/code-generator/
RUN make operator-sdk
RUN make go-gen
RUN make operator OPERATOR_IMAGE=$OPERATOR_IMAGE

FROM ${BASE_IMAGE}
LABEL name="StorageOS Cluster Operator" \
    maintainer="support@storageos.com" \
    vendor="StorageOS" \
    version="v2.4.4" \
    release="2" \
    distribution-scope="public" \
    architecture="x86_64" \
    url="https://docs.storageos.com" \
    io.k8s.description="The StorageOS Cluster Operator installs and manages StorageOS within a cluster." \
    io.k8s.display-name="StorageOS Cluster Operator" \
    io.openshift.tags="storageos,storage,operator,pv,pvc,storageclass,persistent,csi" \
    summary="Highly-available persistent block storage for containerized applications." \
    description="StorageOS transforms commodity server or cloud based disk capacity into enterprise-class storage to run persistent workloads such as databases in containers. Provides high availability, low latency persistent block storage. No other hardware or software is required."

# Create a working directory that's writable by non-root users. This is needed
# for writing the certificate generation.
WORKDIR /home/operator
RUN chmod -R g+rwX /home/operator

# Docker is required by the upgrader to pre-load images.  Only `docker pull` is
# used.  `podman` would be preferred but it's not available in the package repo,
# and there isn't a binary release that we can easily download into the image.
RUN microdnf update && \
    microdnf install gzip openssl tar wget
RUN \
    wget --no-check-certificate -q https://download.docker.com/linux/static/stable/x86_64/docker-17.03.0-ce.tgz && \
    tar -xvzf docker-17.03.0-ce.tgz && \
    cp docker/docker /bin/ && \
    rm -rf docker* && \
    chmod +x /bin/docker && rm docker-17.03.0-ce.tgz
RUN mkdir -p /licenses
COPY --from=build /go/src/github.com/storageos/cluster-operator/LICENSE /licenses/
COPY --from=build /go/src/github.com/storageos/cluster-operator/build/_output/bin/cluster-operator /usr/local/bin/cluster-operator
COPY --from=build /go/src/github.com/storageos/cluster-operator/build/_output/bin/upgrader /usr/local/bin/upgrader
COPY --from=build /go/src/github.com/storageos/cluster-operator/cmd/image-puller/docker-puller.sh /usr/local/bin/docker-puller.sh

# Set a non-root default user.
USER 1001
