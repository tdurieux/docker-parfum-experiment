FROM fedora:36

# Unless specified otherwise, compress to a medium level which gives (from experemintation) a
# good balance between compression time and resulting image size.
ARG UPX_LEVEL=-5
ENV DAPPER_HOST_ARCH=amd64 SHIPYARD_DIR=/opt/shipyard SHELL=/bin/bash \
    DAPPER_RUN_ARGS="--net=kind"
ENV HOST_ARCH=${DAPPER_HOST_ARCH} ARCH=${DAPPER_HOST_ARCH} PATH=/root/.local/bin:/go/bin:/usr/local/go/bin:$PATH \
    GOLANG_ARCH_amd64=amd64 GOLANG_ARCH_arm=armv6l GOLANG_ARCH=GOLANG_ARCH_${DAPPER_HOST_ARCH} \
    GOPATH=/go GO111MODULE=on GOFLAGS=-mod=vendor GOPROXY=https://proxy.golang.org \
    SCRIPTS_DIR=${SHIPYARD_DIR}/scripts

# Requirements:
# Component        | Usage
# -------------------------------------------------------------
# curl             | download other tools
# findutils        | make unit (find unit test dirs)
# gcc              | needed by `go test -race` (https://github.com/golang/go/issues/27089)
# gh               | backport, releases
# ginkgo           | tests
# git              | find the workspace root
# gitlint          | Commit message linting
# golang           | build
# golangci-lint    | code linting
# helm             | e2e tests
# jq               | JSON processing (GitHub API)
# kind             | e2e tests
# kubectl          | e2e tests (in kubernetes-client)
# make             | OLM installation
# markdownlint     | Markdown linting
# moby-engine      | Docker (for Dapper)
# npm              | Required for installing markdownlint
# qemu-user-static | Emulation (for multiarch builds)
# ShellCheck       | shell script linting
# skopeo           | container image manipulation
# subctl *         | Submariner's deploy tool (operator)
# upx              | binary compression
# yamllint         | YAML linting
# yq               | YAML processing (OCM deploy tool)

# This layer's versioning is handled by dnf, and isn't expected to be rebuilt much except in CI
RUN dnf -y install --nodocs --setopt=install_weak_deps=False \
                   gcc git-core curl moby-engine make golang kubernetes-client \
                   findutils upx jq ShellCheck npm gitlint yamllint \
                   qemu-user-static python3-pip skopeo && \
    npm install -g markdownlint-cli && \
    pip install --no-cache-dir j2cli[yaml] --user && \
    rpm -e --nodeps containerd npm python3-pip && \
    rpm -qa "selinux*" | xargs -r rpm -e --nodeps && \
    dnf -y clean all && \
    rm -f /usr/bin/{dockerd,lto-dump} \
          /usr/libexec/gcc/x86_64-redhat-linux/10/lto1 && \
    find /usr/bin /usr/lib/golang /usr/libexec -type f -executable -newercc /proc -size +1M ! -name hyperkube \( -execdir upx ${UPX_LEVEL} {} \; -o -true \) && \
    ln -f /usr/bin/kubectl /usr/bin/hyperkube && npm cache clean --force;

ENV LINT_VERSION=v1.46.0 \
    HELM_VERSION=v3.9.0 \
    KIND_VERSION=v0.12.0 \
    BUILDX_VERSION=v0.8.2 \
    GH_VERSION=2.5.1 \
    YQ_VERSION=4.20.2

# This layer's versioning is determined by us, and thus could be rebuilt more frequently to test different versions
# We temporarily install kind-0.12 and kind-0.14; kind-0.12 is the default, and kind-0.14 is used for K8s 1.24, until
# all kind images are available with containerd 1.6.5 or later
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin -d ${LINT_VERSION} && \
    i=0; while curl -f "https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" | tar -xzf -; ; do \
     do if ((++i > 5)); then break; fi; sleep 1; \
   done && \
    mv linux-${ARCH}/helm /go/bin/ && chmod a+x /go/bin/helm && rm -rf linux-${ARCH} && \
    curl -f -Lo /go/bin/kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.12.0/kind-linux-${ARCH}" && chmod a+x /go/bin/kind && \
    curl -f -Lo /go/bin/kind-0.14 "https://github.com/kubernetes-sigs/kind/releases/download/v0.14.0/kind-linux-${ARCH}" && chmod a+x /go/bin/kind-0.14 && \
    GOFLAGS="" go install -v github.com/onsi/ginkgo/ginkgo@latest && \
    GOFLAGS="" go install -v github.com/mikefarah/yq/v4@v${YQ_VERSION} && \
    mkdir -p /usr/local/libexec/docker/cli-plugins && \
    curl -f -L "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-${ARCH}" -o /usr/local/libexec/docker/cli-plugins/docker-buildx && \
    chmod 755 /usr/local/libexec/docker/cli-plugins/docker-buildx && \
    curl -f -L https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${ARCH}.tar.gz | tar xzf - && \
    mv gh_${GH_VERSION}_linux_${ARCH}/bin/gh /go/bin/ && \
    rm -rf gh_${GH_VERSION}_linux_${ARCH} && \
    find /go/bin /usr/local/libexec/docker/cli-plugins -type f -executable -newercc /proc -exec strip {} + && \
    find /go/bin /usr/local/libexec/docker/cli-plugins -type f -executable -newercc /proc \( -execdir upx ${UPX_LEVEL} {} \; -o -true \) && \
    go clean -cache -modcache

# Copy kubecfg to always run on the shell
COPY scripts/shared/lib/kubecfg /etc/profile.d/kubecfg.sh

# Copy shared files so that downstream projects can use them
COPY Makefile.* .gitlint ${SHIPYARD_DIR}/

# Copy the global dapper file so that we can make sure consuming projects are up to date
COPY Dockerfile.dapper ${SHIPYARD_DIR}/

# Copy CI deployment scripts into image to share with all submariner-io/* projects
WORKDIR $SCRIPTS_DIR
COPY scripts/shared/ .
