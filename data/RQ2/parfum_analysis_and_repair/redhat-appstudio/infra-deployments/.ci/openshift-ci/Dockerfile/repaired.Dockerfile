FROM registry.ci.openshift.org/openshift/release:golang-1.17

SHELL ["/bin/bash", "-c"]

# Install yq, kubectl, kustomize
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin
