ARG CDEV_VERSION
ARG PYTHON_VERSION=3.9.4-slim-buster

FROM clusterdev/cluster.dev:${CDEV_VERSION} as clusterdev

FROM python:${PYTHON_VERSION}

RUN pip3 install --no-cache-dir awscli gcloud azure-cli doctl

RUN apt-get update -y && apt-get install --no-install-recommends -y git curl jq \
    && curl -f -LO "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && rm -rf /var/lib/apt/lists/*;

COPY --from=clusterdev /bin/terraform /bin/terraform
COPY --from=clusterdev /bin/cdev /bin/cdev

WORKDIR /workspace/cluster-dev

ENTRYPOINT ["/bin/cdev"]
