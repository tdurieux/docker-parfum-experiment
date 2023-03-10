ARG DOCKER_VERSION="20.10.8"
FROM jieyu/dind-buster:v${DOCKER_VERSION}

ARG KUBECTL_VERSION="v1.21.2"
ARG KIND_VERSION="v0.11.1"

RUN curl -f -Lso /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x /usr/bin/kubectl && \
    curl -f -Lso /usr/bin/kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64" && \
    chmod +x /usr/bin/kind

COPY kind-config.yaml /kind-config.yaml

EXPOSE 30001

RUN mv /entrypoint.sh /entrypoint-original.sh
COPY entrypoint-wrapper.sh /entrypoint.sh
