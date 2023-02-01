FROM gitpod/workspace-full

USER root

RUN curl -f -o /usr/local/bin/kubectl -LO "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl

RUN curl -f -L https://github.com/kubernetes-sigs/kubebuilder/releases/download/v2.3.1/kubebuilder_2.3.1_$(go env GOOS)_$(go env GOARCH).tar.gz | \
    tar -xz -C /tmp/ && mv /tmp/kubebuilder_2.3.1_$(go env GOOS)_$(go env GOARCH) /usr/local/kubebuilder

ENV GOCACHE=/go-build-cache

RUN apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;
RUN go install github.com/mattn/goreman@latest

USER gitpod

ENV ARGOCD_REDIS_LOCAL=true
ENV KUBECONFIG=/tmp/kubeconfig
