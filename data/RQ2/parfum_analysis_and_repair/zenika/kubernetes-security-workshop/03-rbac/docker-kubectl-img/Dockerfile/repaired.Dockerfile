FROM ubuntu:18.04

ENV KUBECTL_VERSION="v1.12.2"

RUN apt update && \
  apt install --no-install-recommends -y curl && \
  curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
  cp kubectl /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && rm -rf /var/lib/apt/lists/*;

