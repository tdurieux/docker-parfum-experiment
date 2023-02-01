FROM debian:stretch as downloader

ARG HELM_VERSION=v2.17.0
ARG HELM_SHA256SUM="f3bec3c7c55f6a9eb9e6586b8c503f370af92fe987fcbf741f37707606d70296"

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    curl -f --location "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" > helm.tar.gz && \
    echo "${HELM_SHA256SUM}  helm.tar.gz" | sha256sum --check && \
    tar xzvf helm.tar.gz && \
    chmod +x /linux-amd64/helm && rm helm.tar.gz && rm -rf /var/lib/apt/lists/*;

FROM alpine:3.14.2
RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash ca-certificates
COPY --from=downloader /linux-amd64/helm /usr/bin/helm
COPY kube-score /usr/bin/kube-score
