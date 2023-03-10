FROM ubuntu:16.04
LABEL maintainer="LitmusChaos"
RUN apt-get update || true \
    && apt-get install --no-install-recommends -y curl libgetopt++-dev && rm -rf /var/lib/apt/lists/*;
ENV KUBE_LATEST_VERSION="v1.8.2"
RUN curl -f -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl
COPY stern /usr/local/bin
COPY logger.sh nodelogger.yaml /

