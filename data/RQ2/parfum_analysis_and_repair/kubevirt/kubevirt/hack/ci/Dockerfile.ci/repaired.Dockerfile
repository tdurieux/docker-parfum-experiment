FROM registry.svc.ci.openshift.org/openshift/release:golang-1.13 AS builder
WORKDIR /go/src/kubevirt.io/kubevirt
COPY tests/default-config.json tests/
COPY hack/ci/entrypoint.sh /

ENV BIN_DIR=/usr/local/bin \
    DOCKER_PREFIX='kubevirt' \
    KUBEVIRT_TESTS_FOCUS='-ginkgo.focus=\[rfe_id:273\]\[crit:high\]'

# required to avoid permission error when trying to download tests binary later on
RUN mkdir -p "$BIN_DIR" && chmod -R 777 "$BIN_DIR"

# download oc binary
RUN cd "$BIN_DIR" && \
    curl -f https://mirror2.openshift.com/pub/openshift-v4/clients/oc/4.4/linux/oc.tar.gz | tar -C . -xzf - && \
    chmod +x oc && \
    ln -s oc kubectl
