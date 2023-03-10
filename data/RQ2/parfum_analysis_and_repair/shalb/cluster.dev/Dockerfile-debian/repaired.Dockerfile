ARG CDEV_VERSION
ARG DEBIAN_VERSION=10.9-slim

FROM clusterdev/cluster.dev:${CDEV_VERSION} as clusterdev

FROM debian:${DEBIAN_VERSION}

RUN apt-get update -y && apt-get install --no-install-recommends -y git bash curl jq \
    && curl -f -LO "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && rm -rf /var/lib/apt/lists/*;

COPY --from=clusterdev /bin/terraform /bin/terraform
COPY --from=clusterdev /bin/cdev /bin/cdev

WORKDIR /workspace/cluster-dev

ENTRYPOINT ["/bin/cdev"]
