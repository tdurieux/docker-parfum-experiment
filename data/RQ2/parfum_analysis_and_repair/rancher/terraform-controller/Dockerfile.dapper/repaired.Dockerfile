FROM golang:1.16.2-alpine3.12

ARG DAPPER_HOST_ARCH
ENV ARCH $DAPPER_HOST_ARCH
ENV HELM_VERSION v3.4.2
ENV HELM_URL_V3=https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz

RUN apk -U --no-cache add bash git gcc musl-dev docker vim less file curl wget ca-certificates
RUN curl -f -sL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.38.0

ENV K3S_VERSION v1.18.3+k3s1
#integration tests only support amd64
RUN if [ "${ARCH}" == "amd64" ]; then \
        curl -f -sL https://github.com/rancher/k3s/releases/download/${K3S_VERSION}/k3s > /usr/bin/k3s \
        && chmod +x /usr/bin/k3s; \
    fi

RUN mkdir /usr/tmp && \
    curl -f ${HELM_URL_V3} | tar xvzf - --strip-components=1 -C /usr/tmp/ && \
    mv /usr/tmp/helm /usr/bin/helm

ENV DAPPER_RUN_ARGS --privileged
VOLUME /var/lib/rancher/k3s
VOLUME /var/lib/cni
VOLUME /var/log

ENV DAPPER_ENV REPO TAG DRONE_TAG
ENV DAPPER_SOURCE /go/src/github.com/rancher/terraform-controller/
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
ENV TRASH_CACHE ${DAPPER_SOURCE}/.trash-cache
ENV HOME ${DAPPER_SOURCE}
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
