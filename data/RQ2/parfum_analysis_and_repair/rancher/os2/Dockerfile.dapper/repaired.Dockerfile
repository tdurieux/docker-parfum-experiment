FROM opensuse/leap:15.3
RUN sed -i -s 's/^# rpm.install.excludedocs/rpm.install.excludedocs/' /etc/zypp/zypp.conf && \
    sed -i 's/download/provo-mirror/g' /etc/zypp/repos.d/*repo
RUN zypper ref

ARG DAPPER_HOST_ARCH
ENV ARCH $DAPPER_HOST_ARCH

RUN zypper in -y bash git gcc docker vim less file curl wget ca-certificates make mkisofs go1.16 qemu-tools trousers-devel helm
RUN go get golang.org/x/tools/cmd/goimports
RUN if [ "${ARCH}" == "amd64" ]; then \
        curl -f -sL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.40.1; \
    fi

ENV DOCKER_BUILDKIT 1
ENV DOCKER_CLI_EXPERIMENTAL enabled
ENV DAPPER_ENV REPO TAG DRONE_TAG CROSS DOCKER_USERNAME DOCKER_PASSWORD AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION
ENV DAPPER_SOURCE /go/src/github.com/rancher/os2/
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_RUN_ARGS "-v ros-go16-pkg-1:/go/pkg -v ros-go16-cache-1:/root/.cache/go-build"
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
