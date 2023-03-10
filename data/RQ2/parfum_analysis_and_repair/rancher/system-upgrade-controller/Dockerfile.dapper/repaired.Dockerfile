ARG KUBECTL=rancher/kubectl:v1.21.9
FROM ${KUBECTL} AS kubectl

FROM registry.suse.com/bci/golang:1.17-11.33

COPY --from=kubectl /bin/kubectl /usr/local/bin/kubectl
# COPY --from=sonobuoy /sonobuoy /usr/local/bin/sonobuoy

ARG DAPPER_HOST_ARCH
ENV ARCH $DAPPER_HOST_ARCH

RUN zypper -n install expect git jq  docker vim less file curl wget iproute2 gawk
# Manual install of docker-compose, only needed for e2e tests on amd64
RUN if [ "${ARCH}" == "amd64" ]; then \
        curl -f -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose && \
        chmod +x /usr/local/bin/docker-compose; \
    fi
RUN go install github.com/mgechev/revive@v1.1.1 && \
    rm -rf /go/src /go/pkg
RUN go install golang.org/x/tools/cmd/goimports@latest && \
    rm -rf /go/src /go/pkg
RUN if [ "$(go env GOARCH)" = "amd64" ]; then \
        curl -f -sL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.41.1; \
    fi
RUN if [ "${ARCH}" == "amd64" ]; then \
        go get sigs.k8s.io/kustomize/kustomize/v3@v3.5.4; \
    fi
ARG SONOBUOY_VERSION=0.56.2
RUN if [ "${ARCH}" != "arm" ] && [ "${ARCH}" != "s390x" ]; then \
        set -x; \
        curl -f -sL "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION}_linux_${ARCH}.tar.gz" \
        | tar -xz -C /usr/local/bin; \
        chmod +x /usr/local/bin/sonobuoy; \
    fi
# ENV DAPPER_RUN_ARGS --privileged
ENV DAPPER_ENV REPO TAG DRONE_TAG
ENV DAPPER_SOURCE /go/src/github.com/rancher/system-upgrade-controller/
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_RUN_ARGS "-v suc-pkg:/go/pkg -v suc-cache:/root/.cache/go-build"
ENV KUBECONFIG /root/.kube/config
ENV KUBEHOST 172.17.0.1
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
