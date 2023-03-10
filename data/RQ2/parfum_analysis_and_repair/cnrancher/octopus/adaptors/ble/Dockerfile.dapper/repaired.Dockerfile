FROM golang:1.13.12-buster
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        xz-utils \
        unzip \
        netcat \
    && rm -rf /var/lib/apt/lists/*

# -- for make rules
## install docker client
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
    && rm -rf /var/lib/apt/lists/*; \
    \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - >/dev/null; \
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker.list; \
    \
    apt-get update -qq && apt-get install -y --no-install-recommends \
        docker-ce-cli=5:19.03.* \
    && rm -rf /var/lib/apt/lists/*; \
    docker --version
## install kubectl
RUN curl -fL "https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/$(go env GOOS)/$(go env GOARCH)/kubectl" -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl; \
    kubectl version --short --client
## install golangci-lint
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
        curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)/bin" v1.27.0; \
        golangci-lint --version; \
    fi
## install controller-gen
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
        GO111MODULE=on go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.3.0; \
        controller-gen --version; \
    fi
## install ginkgo
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
        GO111MODULE=on go get github.com/onsi/ginkgo/ginkgo@v1.13.0; \
        ginkgo version; \
    fi
# -- for make rules

# -- for dapper
ENV DAPPER_RUN_ARGS --privileged --network host
ENV GO111MODULE=off
ENV CROSS=false
ENV DAPPER_ENV CROSS CLUSTER_TYPE DOCKER_USERNAME DOCKER_PASSWORD WITHOUT_MANIFEST ONLY_MANIFEST IGNORE_MISSING DRONE_TAG REPO TAG OS ARCH IMAGE_NAME DIRTY_CHECK
ENV DAPPER_SOURCE /go/src/github.com/rancher/octopus/
ENV DAPPER_OUTPUT ./adaptors/ble/bin ./adaptors/ble/dist ./adaptors/ble/deploy ./adaptors/ble/api
ENV DAPPER_DOCKER_SOCKET true
ENV HOME ${DAPPER_SOURCE}
# -- for dapper

WORKDIR ${DAPPER_SOURCE}
ENTRYPOINT ["make", "-se", "adaptor"]