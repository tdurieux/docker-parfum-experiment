FROM registry.suse.com/bci/golang:1.17
ARG PROXY
ARG GOPROXY
RUN zypper -n install netcat wget curl
RUN zypper install -y -f docker
## install golangci-lint
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
    export HTTPS_PROXY=${PROXY}; \
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.44.0; \
    golangci-lint --version; \
    fi
## install mockgen
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
    GO111MODULE=on go get github.com/golang/mock/mockgen@v1.4.3; \
    mockgen --version; \
    fi
## install ginkgo
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
    GO111MODULE=on go get github.com/onsi/ginkgo/ginkgo@v1.13.0; \
    ginkgo version; \
    fi
## install upx
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
    export HTTPS_PROXY=${PROXY}; \
    curl -f -sSL https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz | tar -xvJf - -C /tmp/; \
    mv /tmp/upx-3.96-amd64_linux/upx /usr/bin/ && rm -rf /tmp/upx-3.96-amd64_linux; \
    fi
# -- for make rules

# -- for dapper
ENV DAPPER_RUN_ARGS --privileged --network host
ENV GO111MODULE=on
ENV AUTOK3S_DEV_MODE=true
ENV DAPPER_ENV CROSS DRONE_TAG REPO TAG OS ARCH IMAGE_NAME DIRTY_CHECK
ENV DAPPER_SOURCE /go/src/github.com/cnrancher/autok3s/
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
ENV HOME ${DAPPER_SOURCE}
# -- for dapper

WORKDIR ${DAPPER_SOURCE}
ENTRYPOINT ["hack/make-rules/autok3s.sh"]
