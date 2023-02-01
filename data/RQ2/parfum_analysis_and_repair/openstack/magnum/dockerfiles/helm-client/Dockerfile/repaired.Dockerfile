ARG HELM_VERSION=v3.2.0
FROM debian:buster-slim

ARG HELM_VERSION

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        bash \
    && curl -f -o helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mkdir -p helm \
    && tar zxvf helm.tar.gz -C helm \
    && cp helm/linux-amd64/helm /usr/local/bin \
    && chmod +x /usr/local/bin/helm \
    && rm -rf helm* && rm helm.tar.gz && rm -rf /var/lib/apt/lists/*;
