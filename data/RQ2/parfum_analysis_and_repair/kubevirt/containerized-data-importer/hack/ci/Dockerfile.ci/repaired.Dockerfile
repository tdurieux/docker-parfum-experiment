FROM quay.io/kubevirt/kubevirt-cdi-bazel-builder:2203231247-92ab271e AS builder
WORKDIR /go/src/github.com/kubevirt.io/containerized-data-importer
COPY . .

ENV KUBEVIRT_RUN_UNNESTED=true

RUN dnf -y install make podman && \
    curl -f -L -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v1.19.2/bin/linux/amd64/kubectl" && \
    chmod a+x /usr/bin/kubectl

RUN source /etc/profile.d/gimme.sh && \
    export GOPATH="/go" && \
    ./hack/ci/build.sh

ENTRYPOINT [ "/entrypoint-bazel.sh" ]
CMD ["./hack/ci/test.sh"]
